//
//  VocabItem.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

struct VocabItem: Codable, Identifiable, Equatable {
    static let placeholderItem: VocabItem = VocabItem(word: "Studying Complete", pronunciation: "You have completed your studying for today", meaning: "", priority: -1, lastBreak: 0, state: .mastered)
    
    var id: UUID = UUID()
    var word: String
    var pronunciation: String?
    var meaning: String
    var priority: Int
    var lastBreak: Int
    var state: VocabState
    var nextReviewDate: Date? // Note: Must be non-nil if state is .learning
    
    enum CodingKeys: String, CodingKey {
        case word
        case pronunciation
        case meaning
        case priority
        case lastBreak
        case state
        case nextReviewDate
    }
    
    // Needs to check all fields or bindings get messed up (won't allow changes if the changes don't change the equality of the object)
    static func ==(lhs: VocabItem, rhs: VocabItem) -> Bool {
        return equalIn(\.id, lhs, rhs) &&
        equalIn(\.word, lhs, rhs) &&
        equalIn(\.pronunciation, lhs, rhs) &&
        equalIn(\.meaning, lhs, rhs) &&
        equalIn(\.priority, lhs, rhs) &&
        equalIn(\.lastBreak, lhs, rhs) &&
        equalIn(\.state, lhs, rhs) &&
        equalIn(\.nextReviewDate, lhs, rhs)
    }
    
    private static func equalIn<T: Equatable>(_ property: KeyPath<VocabItem, T>, _ lhs: VocabItem, _ rhs: VocabItem) -> Bool {
        return lhs[keyPath: property] == rhs[keyPath: property]
    }
    
    static func nextBreakAndReviewDate(after currentBreak: Int, from date: Date, action: NextBreakAction) -> (Int, Date) {
        var result: Int = 0
        
        switch action {
        case .reset:
            result = Config.mistakeReviewTime
        case .advance:
            result = Config.reviewTimes.first(where: { t in t > currentBreak }) ?? Config.reviewTimes.last!
        case .remain:
            result = currentBreak
        }
        
        return (result, date.add(result, .minute))
    }
    
    enum NextBreakAction {
        case reset
        case remain
        case advance
    }
}
