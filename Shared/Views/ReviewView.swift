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
    @State var showPronunciation = false
    @State var showMeaning = false
    @State var lastReviewDate = Date()
    
    var isCompletionPlaceholder: Bool {
        return document.currentItem.state == .mastered
    }
    
    var body: some View {
        VStack {
            if showMeaning {
                // Back of card
                HStack {
                    Button(action: master) {
                        Label("Mark as Perfected", systemImage: "star.fill")
                            .foregroundColor(.background)
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.yellow)
                            .cornerRadius(5)
                    }
                    .padding(.leading)
                    Spacer()
                    Text("#\(document.currentItem.priority)")
                        .font(.headline)
                        .padding()
                }
                Text(document.currentItem.word)
                    .font(.largeTitle)
                    .padding(.vertical)
                if let pronunciation = document.currentItem.pronunciation {
                    Text(pronunciation)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                }
                Spacer()
                Text(document.currentItem.meaning)
                    .font(.largeTitle)
                    .padding(.vertical)
                    .onTapGesture(perform: toggleMeaning)
                Spacer()
                Spacer()
                HStack(spacing: 1.5) {
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
                .padding(.top, 1.5)
                .background(Color.primary)
                .font(.system(size: 80))
                .ignoresSafeArea()
            } else {
                // Front of card
                Spacer()
                Text(document.currentItem.word)
                    .onTapGesture(perform: toggleMeaning)
                    .font(.largeTitle)
                if let pronunciation = document.currentItem.pronunciation {
                    Text(isCompletionPlaceholder || showPronunciation ? pronunciation : "Tap to reveal pronunciation")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                        .padding(.bottom, 40)
                        .padding(.top, 20)
                        .padding(.horizontal, 40) // Make it easier to tap
                        .background(Color.background)
                        .padding(.top, -20)
                        .onTapGesture {
                            showPronunciation = !showPronunciation
                        }
                }
                Spacer()
                
                HStack{
                    Spacer()
                }
            }
        }
        .background(Color.background.onTapGesture(perform: toggleMeaning))
        .navigationTitle("Study")
    }
    
    func master() -> Void {
        lastReviewDate = Date()
        document.masterItem()
        toastColor = .yellow
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = "Mastered \(document.currentItem.word)"
            reset()
            document.nextItem()
        }
    }
    
    func review(success: Bool) -> Void {
        lastReviewDate = Date()
        let delay = document.reviewItem(success: success)
        toastColor = success ? .green : .red
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = "+\(Date.minutesToShortText(minutes: delay))"
            reset()
            document.nextItem()
        }
    }
    
    func reset() -> Void {
        showPronunciation = false
        showMeaning = false
    }
    
    func toggleMeaning() {
        if isCompletionPlaceholder {
            // On tap, check if it's a new day, in which case new words may be available
            if !lastReviewDate.isSameDay(as: Date()) {
                lastReviewDate = Date()
                document.nextItem()
            }
        } else {
            showMeaning = !showMeaning
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(document: .constant(Vocab_ToolDocument(list: .sample)), toastMessage: .constant(""), toastColor: .constant(.green))
    }
}
