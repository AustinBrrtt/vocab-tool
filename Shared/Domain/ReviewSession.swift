//
//  ReviewSession.swift
//  Vocab Tool
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

class ReviewSession {
    var reviewIndex = 0
    var vocabList: Binding<VocabList>
    let reviewSize = 25
    
    var currentItem: VocabItem {
        hasItem
        ? vocabList.wrappedValue.items[reviewIndex]
        : VocabItem(word: "List Complete", meaning: "You have mastered all items in this list", priority: -1, state: .mastered)
    }
    
    var hasItem: Bool {
        return reviewIndex >= 0 && reviewIndex < vocabList.wrappedValue.items.count
    }
    
    // Initializes reviewPool with first reviewSize items in "learning" state.
    // If there are fewer than reviewSize such items, then "untouched" items are added up to the max length
    // The remaining "learning" and "untouched" (not "mastered") items are held in the unexplored set to be added later if needed
    init(vocabList: Binding<VocabList>) {
        self.vocabList = vocabList
        nextItem()
    }
    
    private func nextItem(updateCurrent: () -> Void = {}) -> Void {
        if hasItem {
            updateCurrent()
        }
        
        let learningItems = vocabList.wrappedValue.items.filter({ item in item.state == .learning }).sorted(by: { a, b in a.nextReviewDate! < b.nextReviewDate! })
        if learningItems.count > 0, let idx = vocabList.wrappedValue.items.firstIndex(of: learningItems[0]) {
            reviewIndex = idx
            return
        }
        
        let untouchedItems = vocabList.wrappedValue.items.filter({ item in item.state == .untouched })
        if untouchedItems.count > 0, let idx = vocabList.wrappedValue.items.firstIndex(of: untouchedItems[0]) {
            reviewIndex = idx
            return
        }
        
        reviewIndex = -1
    }
    
    func masterItem() -> Void {
        nextItem {
            vocabList.wrappedValue.items[reviewIndex].state = .mastered
        }
    }
    
    func markItemGood() -> Void {
        nextItem {
            vocabList.wrappedValue.items[reviewIndex].state = .learning
            vocabList.wrappedValue.items[reviewIndex].nextReviewDate = Date.now.add(10, .minute) // TODO: Spaced Repitition
        }
    }
    
    func markItemBad() -> Void {
        nextItem {
            vocabList.wrappedValue.items[reviewIndex].state = .learning
            vocabList.wrappedValue.items[reviewIndex].nextReviewDate = Date.now.add(1, .minute) // TODO: Spaced Repitition
        }
    }
}
