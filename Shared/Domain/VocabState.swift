//
//  VocabState.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

enum VocabState: String, Codable {
    static let all: [VocabState] = [.untouched, .learning, .mastered]
    
    case untouched = "untouched"
    case learning = "learning"
    case mastered = "mastered"
}
