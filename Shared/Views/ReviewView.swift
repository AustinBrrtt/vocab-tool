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
    @State var showReverse = false
    @State var lastReviewDate = Date()
    
    var isCompletionPlaceholder: Bool {
        return document.currentItem.state == .mastered
    }
    
    var body: some View {
        VStack {
            HStack {
                if showReverse {
                    MasterButtonView(master: master)
                }
                Spacer()
            }
            .frame(height: 50)
            
            Spacer(minLength: 1)
            
            FlashCardView(showReverse: $showReverse, item: document.currentItem, isCompletionPlaceholder: isCompletionPlaceholder, onCardFlip: onCardFlip)
            
            Spacer(minLength: 1)
            
            HStack {
                if showReverse {
                    ReviewButtonsView(review: review)
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
            reset()
            document.nextItem()
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
            reset()
            document.nextItem()
        }
    }
    
    func reset() -> Void {
        showPronunciation = false
        showReverse = false
    }
    
    func toggleMeaning() -> Void {
        showReverse = !showReverse // TODO
        onCardFlip()
    }
    
    func onCardFlip() -> Void {
        if isCompletionPlaceholder {
            // On tap, check if it's a new day, in which case new words may be available
            if !lastReviewDate.isSameDay(as: Date()) {
                lastReviewDate = Date()
                document.nextItem()
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(document: .constant(Vocab_ToolDocument(list: .sample)), toastMessage: .constant(""), toastColor: .constant(.green))
    }
}
