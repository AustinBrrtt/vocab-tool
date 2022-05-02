//
//  ReviewView.swift
//  Vocab Tool
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct ReviewView: View {
    @Binding var vocabList: VocabList
    @Binding var toastMessage: String
    @Binding var toastColor: Color
    @State var reviewSession: ReviewSession
    @State var showPronunciation = false
    @State var showMeaning = false
    
    init(vocabList: Binding<VocabList>, toastMessage: Binding<String>, toastColor: Binding<Color>) {
        self._vocabList = vocabList
        self._toastMessage = toastMessage
        self._toastColor = toastColor
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
                        review(success: false)
                    }
                    Spacer()
                    Button("Right") {
                        review(success: true)
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
    
    func review(success: Bool) -> Void {
        let delay = reviewSession.reviewItem(success: success)
        toastColor = success ? .green : .red
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = "+\(Date.minutesToShortText(minutes: delay))"
            reset()
            reviewSession.nextItem()
        }
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
        ReviewView(vocabList: .constant(.sample), toastMessage: .constant(""), toastColor: .constant(.green))
    }
}
