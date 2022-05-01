//
//  VocabList.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

extension VocabList {
    static var sample = VocabList(items: [
        VocabItem(word: "iku", meaning: "go", priority: 1, state: .mastered),
        VocabItem(word: "taberu", meaning: "eat", priority: 2, state: .mastered),
        VocabItem(word: "sushi", meaning: "sushi", priority: 3, state: .mastered)
    ])
}
