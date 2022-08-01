//
//  FlashCardReverseView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardReverseView: View {
    let item: VocabItem
    let flipCard: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    FrameSpacer(.horizontal)
                    
                    VStack {
                        Text(item.word)
                            .font(.largeTitle)
                            .padding(.vertical)
                        if let pronunciation = item.pronunciation {
                            Text(pronunciation)
                                .foregroundColor(.secondary)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("#\(item.priority)")
                            .font(.headline)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                Spacer()
            }.frame(maxHeight: .infinity)
            
            Text(item.meaning)
                .font(.largeTitle)
                .padding(.vertical)
                .onTapGesture(perform: flipCard)
            
            FrameSpacer(.vertical)
        }
    }
}

struct FlashCardReverseView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(showReverse: .constant(true), item: VocabList.sample.items[0], isCompletionPlaceholder: false)
    }
}
