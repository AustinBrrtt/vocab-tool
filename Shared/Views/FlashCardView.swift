//
//  FlashCardView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardView: View {
    @Binding var showReverse: Bool
    
    let item: VocabItem
    let isCompletionPlaceholder: Bool
    let onCardFlip: () -> Void
    
    init(showReverse: Binding<Bool>, item: VocabItem, isCompletionPlaceholder: Bool, onCardFlip: @escaping () -> Void = {}) {
        self._showReverse = showReverse
        self.item = item
        self.isCompletionPlaceholder = isCompletionPlaceholder
        self.onCardFlip = onCardFlip
    }
    
    var body: some View {
        VStack {
            if showReverse {
                FlashCardReverseView(item: item, flipCard: flipCard)
            } else {
                FlashCardObverseView(item: item, isCompletionPlaceholder: isCompletionPlaceholder, flipCard: flipCard)
            }
        }
        .asCard(onBackgroundTap: flipCard)
    }
    
    func flipCard() {
        onCardFlip()
        
        if !isCompletionPlaceholder {
            showReverse = !showReverse
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardPickerPreview()
        FlashCardView(showReverse: .constant(true), item: VocabItem.placeholderItem, isCompletionPlaceholder: true)
    }
}
