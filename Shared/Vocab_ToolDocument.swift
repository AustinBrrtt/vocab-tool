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
    var progress = 0.0
    
    var currentItem: VocabItem {
        hasItem
        ? vocabList.items[reviewIndex]
        : VocabItem.placeholderItem
    }

    init(list: VocabList = VocabList(items: [], lastStudyDate: Date(), lastStudyDayReviewCount: 0, lastStudyDaySeenCards: Set(), lastStudyDayNewCardCount: 0, maxNewCardsPerDay: 10, maxReviewsPerDay: 40)) { // TODO: Default Sample List for New Documents
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
        updateProgress()
        
        isBackupSpacerCard = false
        currentCardIsNew = false
        
        // If we are able to learn another new card today, choose a new card
        if vocabList.lastStudyDayNewCardCount < vocabList.maxNewCardsPerDay, let idx = vocabList.items.firstIndex(where: { item in item.state == .untouched }) {
            reviewIndex = idx
            currentCardIsNew = true
            return
        }
        
        // All items in a learning state, sorted by due date, with soonest first
        let learningItems = vocabList.items.filter({ item in item.state == .learning }).sorted(by: sortByReviewDate)
        
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
                .sorted(by: { a, b in sortByReviewDate(vocabList.items[a], vocabList.items[b]) })
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
        progress = 1
    }
    
    mutating func masterItem() -> Void {
        if hasItem {
            vocabList.items[reviewIndex].state = .mastered
        }
    }
    
    mutating func reviewItem(success: Bool) -> Int {
        if hasItem {
            let (nextBreak, date) = VocabItem.nextBreakAndReviewDate(
                after: vocabList.items[reviewIndex].lastBreak,
                from: Date(),
                action: success
                    ? (isBackupSpacerCard ? .remain : .advance)
                    : .reset
            )
            
            vocabList.items[reviewIndex].lastBreak = nextBreak
            vocabList.items[reviewIndex].state = .learning
            vocabList.items[reviewIndex].nextReviewDate = date
            return nextBreak
        }
        return 0
    }
    
    private func haveSeenRecently(_ item: VocabItem) -> Bool {
        guard let index = vocabList.items.firstIndex(of: item) else {
            return false
        }
        return recentlySeen.contains(index)
    }
    
    private func isLastItem(_ item: VocabItem) -> Bool {
        return vocabList.items.firstIndex(of: item) == reviewIndex
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
            if let nextReviewDate = item.nextReviewDate, isDateTodayOrSooner(nextReviewDate) && (
                vocabList.lastStudyDaySeenCards.count < vocabList.maxTotalCardsPerDay ||
                vocabList.lastStudyDaySeenCards.contains(vocabList.items.firstIndex(of: item) ?? -42)
            ) {
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
        vocabList.lastStudyDayReviewCount += 1
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
            vocabList.lastStudyDayReviewCount = 0
        }
    }
    
    private func sortByReviewDate(_ lhs: VocabItem, _ rhs: VocabItem) -> Bool {
        if let rightReviewDate = rhs.nextReviewDate {
            if let leftReviewDate = lhs.nextReviewDate {
                // Both sides have a nextReviewDate
                return leftReviewDate < rightReviewDate
            }
            
            // Only lhs has a nextReviewDate
            return false
        }
        
        // Only rhs has a nextReviewDate, or neither have a nextReviewDate
        return false
    }
    
    private func isDateTodayOrSooner(_ date: Date) -> Bool {
        return isSameStudyDay(date) || date < Date()
    }
    
    // TODO: progress is also set to 1 at the end of nextItem(), can that edge case be handled here even though reviewIndex isn't updated until after this call?
    mutating private func updateProgress() -> Void {
        let lastSeen = Array(vocabList.lastStudyDaySeenCards)
        let learningCards = vocabList.items.indices.filter({ vocabList.items[$0].state == .learning }).sorted(by: { a, b in sortByReviewDate(vocabList.items[a], vocabList.items[b]) })
        let untouchedCards = vocabList.items.indices.filter({ vocabList.items[$0].state == .untouched })
        
        // First we must get all the cards that we might encounter today or have encountered today
        // Start with the cards we've already seen
        var reviewCards = lastSeen
        // print("    seen: \(reviewCards.count) \(reviewCards)")
        
        // Next, if we're not done adding new cards, add the new cards we've yet to add for the day
        if vocabList.lastStudyDaySeenCards.count < vocabList.maxNewCardsPerDay {
            reviewCards.append(contentsOf: untouchedCards.prefix(vocabList.maxNewCardsPerDay - vocabList.lastStudyDaySeenCards.count))
        }
        // print("    addNewCards: \(reviewCards.count) \(reviewCards)")
        
        // Then add all the cards that might come up for review today if given the chance
        reviewCards.append(contentsOf: learningCards.filter({ vocabList.items[$0].nextReviewDate == nil || isDateTodayOrSooner(vocabList.items[$0].nextReviewDate!) }).filter({ !vocabList.lastStudyDaySeenCards.contains($0) }))
        // print("    totalPossible: \(reviewCards.count)")
        
        // Then cut off the list after we've hit the maximum number of cards if necessary
        reviewCards = Array(reviewCards.prefix(vocabList.maxTotalCardsPerDay))
        // print("    limitedReviewCards: \(reviewCards.count) \(reviewCards)")
        
        // Now we want to filter out any cards that we're done studying for the day
        let inProgressCards = reviewCards.filter({ vocabList.items[$0].nextReviewDate == nil || isDateTodayOrSooner(vocabList.items[$0].nextReviewDate!) })
        // print("    inProgress: \(inProgressCards.count) \(inProgressCards)")
        
        // We get our final estimate by starting with the number of reviews we've already done today and running our heuristic for remaining reviews on each card that we're not done with yet
        var estimatedTotalReviews = vocabList.lastStudyDayReviewCount
        for idx in inProgressCards {
            estimatedTotalReviews += vocabList.items[idx].estimatedRemainingReviewCount
        }
        // print("    estimate: \(estimatedTotalReviews)")
        
        // Then we devide the number so far by the estimate to estimate the progress. Note that we don't allow the estimated reviews to be below 1 to avoid a divide by zero scenario.
        let rawProgress = Double(vocabList.lastStudyDayReviewCount) / max(Double(estimatedTotalReviews), 1.0)
        // print("    progress: \(vocabList.lastStudyDayReviewCount) / \(estimatedTotalReviews) = \(rawProgress)")
        
        // Finally, since the estimates tend to be much higher in the beginning, we adjust for this by adjusting it so the progress moves faster when it is lower
        progress = sqrt(rawProgress)
        // print("adjusted: \(progress)")
    }
}

