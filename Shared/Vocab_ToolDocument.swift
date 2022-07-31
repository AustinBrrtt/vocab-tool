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
    var recentlySeen = Cache<Int>(size: 3)
    let maxReviewsPerDay = 40 // Maximum reviews before new cards stop being added for a day - This means actual number of reviews will be much higher, likely more than double this
    
    // In Minutes:    10m  1h   1d    3d    7d     10d    15d    30d    60d    90d     180d    365d
    let reviewTimes = [10, 60, 1440, 4320, 10080, 14400, 21600, 43200, 86400, 129600, 259200, 525600]
    let mistakeReviewTime = 1
    
    var currentItem: VocabItem {
        hasItem
        ? vocabList.items[reviewIndex]
        : VocabItem(word: "Studying Complete", pronunciation: "You have completed your studying for today", meaning: "", priority: -1, lastBreak: 0, state: .mastered)
    }

    init(list: VocabList = VocabList(items: [], lastReviewDate: Date(), lastReviewDayCount: 0)) { // TODO: Default Sample List for New Documents
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
        return isSameStudyDay(vocabList.lastReviewDate) && vocabList.lastReviewDayCount >= maxReviewsPerDay
    }
    
    var hasItem: Bool {
        return reviewIndex >= 0 && reviewIndex < vocabList.items.count
    }
    
    mutating func nextItem() -> Void {
        isBackupSpacerCard = false
        if reviewIndex != -1 {
            recentlySeen.remember(reviewIndex)
        }
        
        // If there are any items with "learning" status that are due, show the one with the earliest due date.
        // Otherwise, if the number of items with "learning" status meets or exceeds the maxLearningCount, show the one with the earliest due date.
        let learningItems = vocabList.items.filter({ item in item.state == .learning }).sorted(by: { a, b in a.nextReviewDate! < b.nextReviewDate! })
        if learningItems.count > 0, learningItems[0].nextReviewDate! < Date(), let idx = vocabList.items.firstIndex(of: learningItems[0]) {
            reviewIndex = idx
            return
        }
        
        // If there's room for more "learning" items, select the first item with "untouched" status
        if !timeToWindDown, let idx = vocabList.items.firstIndex(where: { item in item.state == .untouched }) {
            reviewIndex = idx
            return
        }
        
        
        // If winddown is reached, or none are "untouched", go back to the items with "learning" status if there are any with a review date later today
        if learningItems.count > 0, isSameStudyDay(learningItems[0].nextReviewDate!) {
            // Select the one with the earliest due date that we have not reviewed recently
            if let nonRecentItem = learningItems.first(where: { item in !haveSeenRecently(item) }), isSameStudyDay(nonRecentItem.nextReviewDate!), let idx = vocabList.items.firstIndex(of: nonRecentItem) {
                reviewIndex = idx
                return
            }
            
            // In this case, the only card left for today is one we recently looked at, so we'll make an exception and grab a card that we did today and is due tomorrow
            // But we won't increment its review delay if we get it right so it still shows up next tomorrow
            let tomorrow = Date().add(1, .day)
            if let backupItem = learningItems.first(where: { item in item.lastBreak == 1440 && isSameStudyDay(item.nextReviewDate!, tomorrow) && !haveSeenRecently(item) }), let idx = vocabList.items.firstIndex(of: backupItem) {
                isBackupSpacerCard = true
                reviewIndex = idx
                return
            }
            
            // As a last resort before repeating the last card, pick any recently seen card that is not the single most recent
            if let notLastItem = learningItems.first(where: { item in !isLastItem(item) }), isSameStudyDay(notLastItem.nextReviewDate!), let idx = vocabList.items.firstIndex(of: notLastItem) {
                reviewIndex = idx
                return
            }
            
            // There's no other cards to show, so we have no choice but to show this one multiple times in a row
            // If we let new cards get started, cards will be added infinitely
            if let idx = vocabList.items.firstIndex(of: learningItems[0]) {
                reviewIndex = idx
                return
            }
        }
        
        
        // Otherwise, there is nothing to select, so just set the index to -1
        reviewIndex = -1
    }
    
    mutating func masterItem() -> Void {
        if hasItem {
            incrementDailyReviewCount()
            vocabList.items[reviewIndex].state = .mastered
        }
    }
    
    mutating func reviewItem(success: Bool) -> Int {
        if hasItem {
            incrementDailyReviewCount()
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
    
    mutating private func incrementDailyReviewCount() -> Void {
        let now = Date()
        if (!isSameStudyDay(vocabList.lastReviewDate, now)) {
            vocabList.lastReviewDate = now
            vocabList.lastReviewDayCount = 0
        }
        
        vocabList.lastReviewDayCount = vocabList.lastReviewDayCount + 1
    }
}

