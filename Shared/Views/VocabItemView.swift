//
//  VocabItemView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct VocabItemView: View {
    let vocabItem: VocabItem
    let showCard: (VocabItem) -> Void
    var body: some View {
        HStack {
            Text("\(String(vocabItem.priority)). \(vocabItem.word)")
            
            Spacer(minLength: 10)
            
            HStack {
                if vocabItem.state == .learning {
                    Text(Date.minutesToShortText(minutes: vocabItem.lastBreak))
                        .foregroundColor(.secondary)
                }
                Spacer()
                StateIcon(state: vocabItem.state)
            }
            .frame(maxWidth: 75)
        }
        .padding(.vertical)
        .background(Color.background.opacity(0.01).onTapGesture(perform: { showCard(vocabItem) }))
    }
}

struct VocabItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List(VocabList.sample.items) { item in
                VocabItemView(vocabItem: item, showCard: { _ in })
            }
            .padding()
            List(VocabList.sample.items) { item in
                VocabItemView(vocabItem: item, showCard: { _ in })
            }
            .preferredColorScheme(.dark)
            .padding()
        }
    }
}
