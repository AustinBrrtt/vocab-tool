//
//  VocabItemView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct VocabItemView: View {
    var vocabItem: VocabItem
    @State var showMeaning = false
    @State var showPronunciation = false
    
    var leftText: String {
        if (!showPronunciation || vocabItem.pronunciation == nil) {
            return "\(vocabItem.priority). \(vocabItem.word)"
        }
        return "\(vocabItem.priority). \(vocabItem.word) (\(vocabItem.pronunciation!))"
    }
    
    var rightText: String {
        return showMeaning ? vocabItem.meaning : "Tap to Reveal"
    }
    
    var body: some View {
        HStack {
            Text(leftText)
                .onTapGesture {
                    showPronunciation = !showPronunciation
                }
            Spacer()
            if vocabItem.state == .learning {
                Text(Date.minutesToShortText(minutes: vocabItem.lastBreak))
                    .foregroundColor(.secondary)
                Spacer()
            }
            Text(rightText)
                .onTapGesture {
                    showMeaning = !showMeaning
                }
            
            StateIcon(state: vocabItem.state)
        }.padding(.vertical)
    }
}

struct VocabItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List(VocabList.sample.items) { item in
                VocabItemView(vocabItem: item)
            }
            .padding()
            List(VocabList.sample.items) { item in
                VocabItemView(vocabItem: item)
            }
            .preferredColorScheme(.dark)
            .padding()
        }
    }
}
