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
                ZStack(alignment: .top) {
                    VStack {
                        Text(item.word)
                            .font(.largeTitle)
                            .padding(.vertical)
                        if let pronunciation = item.pronunciation {
                            Text(pronunciation)
                                .allowMultiline()
                                .foregroundColor(.secondary)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                        }
                    }
                    .padding(.top)
                    
                    HStack {
                        Spacer()
                        Text("#\(item.priority)")
                            .font(.headline)
                            .padding()
                    }
                }
                Spacer()
            }.frame(maxHeight: .infinity)
            
            Text(item.meaning)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .allowMultiline()
                .padding(.vertical)
                .onTapGesture(perform: flipCard)
            
            FrameSpacer(.vertical)
        }
    }
}

struct FlashCardReverseView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardPickerPreview(showReverse: true)
    }
}
