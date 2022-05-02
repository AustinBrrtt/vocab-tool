//
//  ReviewSession.swift
//  Vocab Tool
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

class ReviewSession {
    var reviewIndex = 0
    var document: Binding<Vocab_ToolDocument>
    let maxLearningCount = 25
    
    // In Minutes:    1m  10m 1h   1d    3d    7d     10d    15d    30d
    let reviewTimes = [1, 10, 60, 1440, 4320, 10080, 14400, 21600, 43200]
    
    var currentItem: VocabItem {
        hasItem
        ? document.vocabList.wrappedValue.items[reviewIndex]
        : VocabItem(word: "Studying Complete", pronunciation: "You have completed your studying for today", meaning: "", priority: -1, lastBreak: 0, state: .mastered)
    }
    
    var hasItem: Bool {
        return reviewIndex >= 0 && reviewIndex < document.vocabList.wrappedValue.items.count
    }
    
    init(document: Binding<Vocab_ToolDocument>) {
        self.document = document
        nextItem()
    }
    
    func nextItem() -> Void {
        // If there are any items with "learning" status that are due, show the one with the earliest due date.
        // Otherwise, if the number of items with "learning" status meets or exceeds the maxLearningCount, show the one with the earliest due date.
        let learningItems = document.vocabList.wrappedValue.items.filter({ item in item.state == .learning }).sorted(by: { a, b in a.nextReviewDate! < b.nextReviewDate! })
        if learningItems.count > 0, learningItems[0].nextReviewDate! < Date(), let idx = document.vocabList.wrappedValue.items.firstIndex(of: learningItems[0]) {
            reviewIndex = idx
            return
        }
        
        // If there's room for more "learning" items, select the first item with "untouched" status
        if learningItems.count < maxLearningCount, let idx = document.vocabList.wrappedValue.items.firstIndex(where: { item in item.state == .untouched }) {
            reviewIndex = idx
            return
        }
        
        
        // If none are "untouched", go back to the items with "learning" status and select the one with the earliest due date, as long as it is this calendar day
        // If next item is for a different calendar day, we are done for the day
        if learningItems.count > 0, learningItems[0].nextReviewDate!.isSameDay(as: Date()), let idx = document.vocabList.wrappedValue.items.firstIndex(of: learningItems[0]) {
            reviewIndex = idx
            return
        }
        
        // Otherwise, there is nothing to select, so just set the index to -1
        reviewIndex = -1
    }
    
    func masterItem() -> Void {
        if hasItem {
            document.vocabList.wrappedValue.items[reviewIndex].state = .mastered
        }
    }
    
    func reviewItem(success: Bool) -> Int {
        if hasItem {
            let (nextBreak, date) = nextReviewTime(for: document.vocabList.wrappedValue.items[reviewIndex], success: success)
            document.vocabList.wrappedValue.items[reviewIndex].lastBreak = nextBreak
            document.vocabList.wrappedValue.items[reviewIndex].state = .learning
            document.vocabList.wrappedValue.items[reviewIndex].nextReviewDate = date
            return nextBreak
        }
        return 0
    }
    
    private func nextReviewTime(for item: VocabItem, success: Bool) -> (Int, Date) {
        // On failure, even if not due yet, jump back to beginning and review soon
        if !success {
            return (reviewTimes.first!, Date().add(reviewTimes.first!, .minute))
        }
        
        // On success, advance to the next time slot
        let result = reviewTimes.first(where: { t in t > item.lastBreak }) ?? reviewTimes.last!
        return (result, Date().add(result, .minute))
    }
}
