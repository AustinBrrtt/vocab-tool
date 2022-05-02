//
//  VocabList.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

extension VocabList {
    static var sample = VocabList(items: [
        VocabItem(word: "iku", meaning: "go", priority: 1, lastBreak: 0, state: .learning, nextReviewDate: Date()),
        VocabItem(word: "taberu", meaning: "eat", priority: 2, lastBreak: 0, state: .learning, nextReviewDate: Date().add(1, .day)),
        VocabItem(word: "sushi", meaning: "sushi", priority: 3, lastBreak: 0, state: .untouched)
    ])
}
