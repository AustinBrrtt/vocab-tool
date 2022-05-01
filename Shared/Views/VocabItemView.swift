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
        print(vocabItem.pronunciation == nil)
        if (!showPronunciation || vocabItem.pronunciation == nil) {
            return vocabItem.word
        }
        return "\(vocabItem.word) (\(vocabItem.pronunciation!))"
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
            Text(rightText)
                .onTapGesture {
                    showMeaning = !showMeaning
                }
        }.padding(.vertical)
    }
}

struct VocabItemView_Previews: PreviewProvider {
    static var previews: some View {
        VocabItemView(vocabItem: VocabList.sample.items[0])
    }
}
