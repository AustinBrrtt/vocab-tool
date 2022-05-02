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
        : VocabItem(word: "List Complete", meaning: "You have mastered all items in this list", priority: -1, lastBreak: 0, state: .mastered)
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
        if learningItems.count > 0, learningItems[0].nextReviewDate! < Date() || learningItems.count >= maxLearningCount, let idx = document.vocabList.wrappedValue.items.firstIndex(of: learningItems[0]) {
            reviewIndex = idx
            return
        }
        
        // There are no items due with "learning" status and there's room for more "learning" items, so select the first item with "untouched" status
        if let idx = document.vocabList.wrappedValue.items.firstIndex(where: { item in item.state == .untouched }) {
            reviewIndex = idx
            return
        }
        
        
        // If none are "untouched", go back to the items with "learning" status and select the one with the earliest due date.
        if learningItems.count > 0, let idx = document.vocabList.wrappedValue.items.firstIndex(of: learningItems[0]) {
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
        var result = 0
        
        if hasItem {
            result = success ? nextReviewTime(after: document.vocabList.wrappedValue.items[reviewIndex].lastBreak) : reviewTimes.first!
            document.vocabList.wrappedValue.items[reviewIndex].lastBreak = result
            document.vocabList.wrappedValue.items[reviewIndex].state = .learning
            document.vocabList.wrappedValue.items[reviewIndex].nextReviewDate = Date.now.add(result, .minute)
        }
        return result
    }
    
    private func nextReviewTime(after prevReviewTime: Int?) -> Int {
        let prev = prevReviewTime ?? 0
        return reviewTimes.first(where: { t in t > prev }) ?? reviewTimes.last!
    }
}
