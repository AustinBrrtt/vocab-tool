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
            FrameSpacer(.vertical)
            
            Text(item.word)
                .onTapGesture(perform: flipCard)
                .font(.largeTitle)
            VStack {
                if let pronunciation = item.pronunciation {
                    Text(isCompletionPlaceholder || showPronunciation ? pronunciation : "Tap to reveal pronunciation")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                        .padding(.bottom, 40)
                        .padding(.top, 20)
                        .padding(.horizontal, 40) // Make it easier to tap
                        .background(Color.background.opacity(0.01))
                        .padding(.top, -20)
                        .onTapGesture {
                            showPronunciation = !showPronunciation
                        }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct FlashCardObverseView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(showReverse: .constant(false), item: VocabList.sample.items[0], isCompletionPlaceholder: false)
    }
}
