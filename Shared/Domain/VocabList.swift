//
//  VocabList.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import Foundation

struct VocabList: Codable {
    var items: [VocabItem]
    var lastStudyDate: Date
    var lastStudyDayReviewCount: Int
    var lastStudyDaySeenCards: Set<Int>
    var lastStudyDayNewCardCount: Int
    var maxNewCardsPerDay: Int
    var maxReviewsPerDay: Int
    
    var maxTotalCardsPerDay: Int {
        maxReviewsPerDay + maxNewCardsPerDay
    }
}
