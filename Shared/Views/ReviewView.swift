//
//  ReviewView.swift
//  Vocab Tool
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct ReviewView: View {
    @Binding var vocabList: VocabList
    @State var reviewSession: ReviewSession
    @State var showPronunciation = false
    @State var showMeaning = false
    
    init(vocabList: Binding<VocabList>) {
        self._vocabList = vocabList
        self._reviewSession = State<ReviewSession>(initialValue: ReviewSession(vocabList: vocabList))
    }
    
    var body: some View {
        VStack {
            if showMeaning {
                Spacer()
                Text(reviewSession.currentItem.meaning)
                    .font(.largeTitle)
                    .padding(.vertical)
                    .onTapGesture(perform: toggleMeaning)
                Spacer()
                HStack {
                    Button("Wrong") {
                        reset()
                        reviewSession.markItemBad()
                    }
                    Spacer()
                    Button("Right") {
                        reset()
                        reviewSession.markItemGood()
                    }
                }
                .padding()
            } else {
                Text(reviewSession.currentItem.word)
                    .onTapGesture(perform: toggleMeaning)
                    .font(.largeTitle)
                    .padding(.vertical)
                if let pronunciation = reviewSession.currentItem.pronunciation {
                    Text(showPronunciation ? pronunciation : "Tap to reveal pronunciation")
                        .onTapGesture {
                            showPronunciation = !showPronunciation
                        }
                }
            }
        }
        .navigationTitle("Review")
    }
    
    func reset() -> Void {
        showPronunciation = false
        showMeaning = false
    }
    
    func toggleMeaning() {
        showMeaning = !showMeaning
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(vocabList: .constant(.sample))
    }
}
