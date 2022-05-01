//
//  VocabItem.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

struct VocabItem: Codable, Identifiable {
    var id: UUID = UUID()
    var word: String
    var pronunciation: String?
    var meaning: String
    var priority: Int
    var state: VocabState
    var nextReviewDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case word
        case pronunciation
        case meaning
        case priority
        case state
        case nextReviewDate
    }
}
