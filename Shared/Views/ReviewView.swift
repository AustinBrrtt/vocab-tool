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
    @State var cardRotation: Double = 0
    @State var lastReviewDate = Date()
    @State var showCard = true
    
    var isCompletionPlaceholder: Bool {
        return document.currentItem.state == .mastered
    }
    
    var body: some View {
        VStack {
            HStack {
                if cardRotation == 180 {
                    MasterButtonView(master: master)
                        .transition(buttonTransition(.leading))
                }
                Spacer()
            }
            .frame(height: 50)
            
            Spacer(minLength: 1)
            
            if showCard {
                FlashCardView(rotation: $cardRotation, item: document.currentItem, isCompletionPlaceholder: isCompletionPlaceholder, onCardFlip: onCardFlip)
                    .transition(.asymmetric(insertion: .slide, removal: .move(edge: .trailing)))
            }
            
            Spacer(minLength: 1)
            
            HStack {
                if cardRotation == 180 {
                    ReviewButtonsView(review: review)
                        .transition(buttonTransition(.bottom))
                }
            }
            .frame(height: 100)
        }
        .background(.regularMaterial)
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
            showNextCard()
        }
    }
    
    func review(_ success: Bool) -> Void {
        lastReviewDate = Date()
        let delay = document.reviewItem(success: success)
        toastColor = success ? .green : .red
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = "+\(Date.minutesToShortText(minutes: delay))"
            showNextCard()
        }
    }
    
    func showNextCard() -> Void {
        let transitionTime = 0.1
        let pauseTime = 0.2
        withAnimation(.linear(duration: transitionTime)) {
            showCard = false
        }
        
        withAnimation(.linear(duration: pauseTime / 3).delay(transitionTime + pauseTime / 3)) {
            showPronunciation = false
            cardRotation = 0
            document.nextItem()
        }
        
        withAnimation(.linear(duration: transitionTime).delay(transitionTime + pauseTime)) {
            showCard = true
        }
    }
    
    func onCardFlip() -> Void {
        if isCompletionPlaceholder {
            // On tap, check if it's a new day, in which case new words may be available
            if !lastReviewDate.isSameDay(as: Date()) {
                lastReviewDate = Date()
            }
        }
    }
    
    func buttonTransition(_ edge: Edge) -> AnyTransition {
        return .asymmetric(insertion: .opacity, removal: .move(edge: edge))
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(document: .constant(Vocab_ToolDocument(list: .sample)), toastMessage: .constant(""), toastColor: .constant(.green))
    }
}
