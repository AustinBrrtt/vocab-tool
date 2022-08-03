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
        VocabItem(word: "お祖父さん", pronunciation: "おじいさん", meaning: "grandfather", priority: 2, lastBreak: 0, state: .learning, nextReviewDate: Date().add(-1, .day)),
        VocabItem(word: "見る", pronunciation: "miru", meaning: "see", priority: 3, lastBreak: 0, state: .learning, nextReviewDate: Date()),
        VocabItem(word: "多い", pronunciation: "ooi", meaning: "many", priority: 4, lastBreak: 163, state: .learning, nextReviewDate: Date().add(1, .day)),
        VocabItem(word: "字", pronunciation: "じ", meaning: "(individual) character,\nletter", priority: 5, lastBreak: 163, state: .learning, nextReviewDate: Date().add(1, .day)),
        VocabItem(word: "怪しい", pronunciation: "あやしい", meaning: "suspicious,\ndubious", priority: 6, lastBreak: 0, state: .untouched),
        VocabItem(word: "donna", meaning: "woman", priority: 5, lastBreak: 7, state: .untouched),
        VocabItem(word: "スーパーマーケット", meaning: "supermarket", priority: 1546, lastBreak: 0, state: .learning, nextReviewDate: Date().add(-1, .day)),
        VocabItem(word: "ドドドドドドドドドドド", pronunciation: "ゴゴゴゴゴゴゴゴゴゴゴゴゴゴゴ", meaning: "menacing,\nlike when Dio Brando looks at you like you're an ant", priority: 2546, lastBreak: 0, state: .learning, nextReviewDate: Date().add(-1, .day)),
        VocabItem(word: "ごみ", meaning: "trash", priority: 8, lastBreak: 0, state: .mastered),
        VocabItem(word: "自炊", pronunciation: "じすい", meaning: "cooking", priority: 9, lastBreak: 0, state: .mastered)
    ], lastStudyDate: Date(), lastStudyDaySeenCards: [], lastStudyDayNewCardCount: 0, maxNewCardsPerDay: 10, maxReviewsPerDay: 40)
}
