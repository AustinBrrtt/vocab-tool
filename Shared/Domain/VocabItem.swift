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
    
    // Only used for allowing Array.firstIndex(of:)
    static func ==(lhs: VocabItem, rhs: VocabItem) -> Bool {
        return lhs.id == rhs.id
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
