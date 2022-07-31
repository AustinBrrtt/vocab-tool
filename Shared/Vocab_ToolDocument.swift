//
//  Vocab_ToolDocument.swift
//  Shared
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var vocabList: UTType {
        UTType(exportedAs: "io.austinbarrett.vocab-tool.list")
    }
}

struct Vocab_ToolDocument: FileDocument {
    var vocabList: VocabList
    var isBackupSpacerCard = false
    var reviewIndex = -1
    var currentCardIsNew = false
    var recentlySeen = Cache<Int>(size: 3)
    
    // In Minutes:    10m  1h   1d    3d    7d     10d    15d    30d    60d    90d     180d    365d
    let reviewTimes = [10, 60, 1440, 4320, 10080, 14400, 21600, 43200, 86400, 129600, 259200, 525600]
    let mistakeReviewTime = 1
    
    var currentItem: VocabItem {
        hasItem
        ? vocabList.items[reviewIndex]
        : VocabItem(word: "Studying Complete", pronunciation: "You have completed your studying for today", meaning: "", priority: -1, lastBreak: 0, state: .mastered)
    }

    init(list: VocabList = VocabList(items: [], lastStudyDate: Date(), lastStudyDaySeenCards: Set(), lastStudyDayNewCardCount: 0, maxNewCardsPerDay: 10, maxReviewsPerDay: 40)) { // TODO: Default Sample List for New Documents
        vocabList = list
        nextItem()
    }

    static var readableContentTypes: [UTType] { [.vocabList] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        do {
            vocabList = try JSONDecoder().decode(VocabList.self, from: data)
        } catch {
            print(error)
            throw CocoaError(.coderInvalidValue)
        }
        nextItem()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let value = try? JSONEncoder().encode(vocabList) else {
            throw CocoaError(.coderInvalidValue)
        }
        return .init(regularFileWithContents: value)
    }
}

// Review Session
extension Vocab_ToolDocument {
    private var timeToWindDown: Bool {
        return isSameStudyDay(vocabList.lastStudyDate) && vocabList.lastStudyDaySeenCards.count >= vocabList.maxTotalCardsPerDay
    }
    
    var hasItem: Bool {
        return reviewIndex >= 0 && reviewIndex < vocabList.items.count
    }
    
    mutating func nextItem() -> Void {
        if reviewIndex != -1 {
            updateHistory(reviewIndex, new: currentCardIsNew)
        }
        
        // By doing this after updating the history, we ensure that the previous item counts towards the day it was selected on, even if we have passed midnight
        updateStudyDateToToday()
        
        isBackupSpacerCard = false
        currentCardIsNew = false
        
        // If we are able to learn another new card today, choose a new card
        if vocabList.lastStudyDayNewCardCount < vocabList.maxNewCardsPerDay, let idx = vocabList.items.firstIndex(where: { item in item.state == .untouched }) {
            reviewIndex = idx
            currentCardIsNew = true
            return
        }
        
        // All items in a learning state, sorted by due date, with soonest first
        let learningItems = vocabList.items.filter({ item in item.state == .learning }).sorted(by: { a, b in a.nextReviewDate! < b.nextReviewDate! })
        
        // If we have any cards in a learning state and either have already seen them today or have capacity to review a new one, take the one with the soonest due date
        // Additional logic inside this block makes a reasonable effort to avoid the same card appearing repeatedly without other cards appearing in between
        if learningItems.count > 0, let searchResult = firstReviewableItem(from: learningItems) {
            let (choice, isRecentlySeen) = searchResult
            
            // If the item has not been seen recently, we will choose it
            if !isRecentlySeen, let idx = vocabList.items.firstIndex(of: choice) {
                reviewIndex = idx
                return
            }
            
            // Try to find a card we reviewed today that doesn't need to be reviewed again today to space out between repetitions of the remaining cards
            // We sort the candidates to ensure that if many backups are used in a session, we cycle through all of them, rather than repeating the first few
            // However, cards with shorter delays will be preferred still, since they in theory should need the additional focus more than those with longer delays
            let backupCandidateIndices = vocabList.lastStudyDaySeenCards
                .filter({ idx in vocabList.items[idx].state == .learning })
                .sorted(by: { a, b in vocabList.items[a].nextReviewDate! < vocabList.items[b].nextReviewDate! })
            if let backupIdx = backupCandidateIndices.first(where: { idx in !isSameStudyDay(vocabList.items[idx].nextReviewDate!) }) {
                reviewIndex = backupIdx
                isBackupSpacerCard = true
                return
            }
            
            // No backup was available, allow the repeated card to be used
            if let idx = vocabList.items.firstIndex(of: choice) {
                reviewIndex = idx
                return
            }
            
        }
        
        // Otherwise, there is nothing to select, so just set the index to -1
        reviewIndex = -1
    }
    
    mutating func masterItem() -> Void {
        if hasItem {
            vocabList.items[reviewIndex].state = .mastered
        }
    }
    
    mutating func reviewItem(success: Bool) -> Int {
        if hasItem {
            let (nextBreak, date) = nextReviewTime(for: vocabList.items[reviewIndex], success: success)
            vocabList.items[reviewIndex].lastBreak = nextBreak
            vocabList.items[reviewIndex].state = .learning
            vocabList.items[reviewIndex].nextReviewDate = date
            return nextBreak
        }
        return 0
    }
    
    private func haveSeenRecently(_ item: VocabItem) -> Bool {
        return recentlySeen.contains(vocabList.items.firstIndex(of: item) ?? -1)
    }
    
    private func isLastItem(_ item: VocabItem) -> Bool {
        return vocabList.items.firstIndex(of: item) == reviewIndex
    }
    
    private func nextReviewTime(for item: VocabItem, success: Bool) -> (Int, Date) {
        // On failure, even if not due yet, jump back to beginning and review soon
        if !success {
            return (mistakeReviewTime, Date().add(reviewTimes.first!, .minute))
        }
        
        // On success, advance to the next time slot (unless this is a backup card, in which case we'll leave it as is)
        let result = isBackupSpacerCard ? item.lastBreak : reviewTimes.first(where: { t in t > item.lastBreak }) ?? reviewTimes.last!
        return (result, Date().add(result, .minute))
    }
    
    private func isSameStudyDay(_ lhs: Date, _ rhs: Date = Date()) -> Bool {
        return lhs.add(-4, .hour).isSameDay(as: rhs.add(-4, .hour)) // TODO: Make offset configurable. -4 means 4 AM treated as midnight.
    }
    
    // If any item was not seen too recently, the first such item will be chosen
    // Otherwise, if any item was not the most recent card, the first such item will be chosen
    // Otherwise, if the most recent item is viable, it will be chosen
    // Otherwise, nil is returned
    // returns (first reviewable item, was the item seen too recently)
    private func firstReviewableItem(from items: [VocabItem]) -> (VocabItem, Bool)? {
        var acceptableItem: VocabItem? // Technically can be used, but was seen recently.
        for item in items {
            if isSameStudyDay(item.nextReviewDate!) && (vocabList.lastStudyDaySeenCards.count < vocabList.maxTotalCardsPerDay || vocabList.lastStudyDaySeenCards.contains(vocabList.items.firstIndex(of: item) ?? -42)) {
                if !haveSeenRecently(item) {
                    return (item, false)
                } else if acceptableItem == nil || isLastItem(acceptableItem!) {
                    acceptableItem = item
                }
            }
        }
        
        if let acceptableItem = acceptableItem {
            return (acceptableItem, true)
        }
        
        return nil
    }
        
    mutating private func updateHistory(_ index: Int, new: Bool) -> Void {
        recentlySeen.remember(index)
        vocabList.lastStudyDaySeenCards.insert(index)
        if new {
            vocabList.lastStudyDayNewCardCount += 1
        }
    }
    
    mutating private func updateStudyDateToToday() -> Void {
        let now = Date()
        if (!isSameStudyDay(vocabList.lastStudyDate, now)) {
            vocabList.lastStudyDate = now
            vocabList.lastStudyDaySeenCards = []
            vocabList.lastStudyDayNewCardCount = 0
        }
    }
}

