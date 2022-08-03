//
//  FlashCardView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardView: View {
    @Binding var rotation: Double
    
    let animationTime = 0.3
    let item: VocabItem
    let isCompletionPlaceholder: Bool
    let onCardFlip: () -> Void
    
    var showReverse: Bool {
        abs(180 - rotation) < 90
    }
    
    init(rotation: Binding<Double>, item: VocabItem, isCompletionPlaceholder: Bool, onCardFlip: @escaping () -> Void = {}) {
        self._rotation = rotation
        self.item = item
        self.isCompletionPlaceholder = isCompletionPlaceholder
        self.onCardFlip = onCardFlip
    }
    
    var body: some View {
        VStack {
            if showReverse {
                FlashCardReverseView(item: item, flipCard: flipCard)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .transitionSuddenly(delay: animationTime / 2)
            } else {
                FlashCardObverseView(item: item, isCompletionPlaceholder: isCompletionPlaceholder, flipCard: flipCard)
                    .transitionSuddenly(delay: animationTime / 2)
            }
        }
        .padding(.horizontal, 9)
        .asCard(onBackgroundTap: flipCard)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    func flipCard() {
        onCardFlip()
        
        if !isCompletionPlaceholder {
            withAnimation(Animation.linear(duration: animationTime)) {
                rotation = (rotation + 180).truncatingRemainder(dividingBy: 360)
            }
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardPickerPreview(showReverse: true, startIndex: 8)
    }
}
