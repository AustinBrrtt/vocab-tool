//
//  ReviewView.swift
//  Vocab Tool
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct ReviewView: View {
    @Binding var document: Vocab_ToolDocument
    @Binding var toastMessage: String
    @Binding var toastColor: Color
    @State var reviewSession: ReviewSession
    @State var showPronunciation = false
    @State var showMeaning = true
    
    init(document: Binding<Vocab_ToolDocument>, toastMessage: Binding<String>, toastColor: Binding<Color>) {
        self._document = document
        self._toastMessage = toastMessage
        self._toastColor = toastColor
        self._reviewSession = State<ReviewSession>(initialValue: ReviewSession(document: document))
    }
    
    var body: some View {
        VStack {
            if showMeaning {
                HStack {
                    Button(action: master) {
                        Label("Perfected", systemImage: "star.fill")
                            .foregroundColor(.background)
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.yellow)
                            .cornerRadius(5)
                    }
                    .padding(.leading)
                    Spacer()
                    Text("#\(reviewSession.currentItem.priority)")
                        .font(.headline)
                        .padding()
                }
                Spacer()
                Text(reviewSession.currentItem.meaning)
                    .font(.largeTitle)
                    .padding(.vertical)
                    .onTapGesture(perform: toggleMeaning)
                Spacer()
                HStack(spacing: 0) {
                    Button(action: {
                        review(success: false)
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "multiply")
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    .background(Color.red)
                    .ignoresSafeArea()
                    
                    Button(action: {
                        review(success: true)
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    .background(Color.green)
                    .ignoresSafeArea()
                }
                .font(.system(size: 80))
                .ignoresSafeArea()
            } else {
                Spacer()
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
                Spacer()
            }
        }
        .navigationTitle("Study")
    }
    
    func master() -> Void {
        reviewSession.masterItem()
        toastColor = .yellow
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = "Mastered \(reviewSession.currentItem.word)"
            reset()
            reviewSession.nextItem()
        }
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
        ReviewView(document: .constant(Vocab_ToolDocument(list: .sample)), toastMessage: .constant(""), toastColor: .constant(.green))
    }
}
