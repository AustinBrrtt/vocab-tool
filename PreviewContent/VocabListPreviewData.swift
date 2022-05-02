//
//  VocabList.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

extension VocabList {
    static var sample = VocabList(items: [
        VocabItem(word: "行く", pronunciation: "iku", meaning: "go", priority: 1, lastBreak: 0, state: .mastered),
        VocabItem(word: "見る", pronunciation: "miru", meaning: "see", priority: 2, lastBreak: 0, state: .learning, nextReviewDate: Date()),
        VocabItem(word: "多い", pronunciation: "ooi", meaning: "many", priority: 3, lastBreak: 163, state: .learning, nextReviewDate: Date().add(1, .day)),
        VocabItem(word: "家", pronunciation: "ie", meaning: "home", priority: 4, lastBreak: 0, state: .untouched),
        VocabItem(word: "donna", meaning: "woman", priority: 5, lastBreak: 0, state: .untouched)
    ])
}
