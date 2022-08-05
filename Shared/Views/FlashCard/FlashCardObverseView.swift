//
//  FlashCardObverseView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardObverseView: View {
    @State var showPronunciation = false
    let item: VocabItem
    let isCompletionPlaceholder: Bool
    let flipCard: () -> Void
    
    var body: some View {
        VStack {
            if item.state == .untouched {
                VStack {
                    Text("New!")
                        .roundRectText(color: .blue)
                        .frame(maxHeight: .infinity)
                    Spacer()
                }
            } else {
                FrameSpacer(.vertical)
            }
            
            
            VStack {
                Text(item.word)
                    .onTapGesture(perform: flipCard)
                    .font(.largeTitle)
                
                if let pronunciation = item.pronunciation {
                    Text(isCompletionPlaceholder || showPronunciation ? pronunciation : "Tap to reveal pronunciation")
                        .roundRectText(color: .secondary)
                        .onTapGesture {
                            showPronunciation = !showPronunciation
                        }
                }
            }
            .frame(maxHeight: .infinity)
            
            FrameSpacer(.vertical)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlashCardObverseView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardPickerPreview(showReverse: false, startIndex: 5)
        FlashCardView(rotation: .constant(0), item: VocabItem.placeholderItem, isCompletionPlaceholder: true)
    }
}
