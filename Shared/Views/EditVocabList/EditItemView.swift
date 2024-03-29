//
//  EditItemView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct EditItemView: View {
    @Binding var item: VocabItem
    
    @State var pronunciation: String = ""
    
    var body: some View {
        Form {
            MirroredTextField("Word", text: $item.word)
            
            MirroredTextField("Pronunciation", text: $pronunciation)
                .onAppear {
                    pronunciation = item.pronunciation ?? ""
                }
                .onChange(of: pronunciation) { newValue in
                    item.pronunciation = newValue.isEmpty ? nil : newValue
                }
            
            MirroredTextField("Meaning", text: $item.meaning)
            
            Picker("State", selection: $item.state) {
                ForEach(VocabState.all, id: \.self) { state in
                    Text(state.rawValue)
                        .tag(state)
                }
            }
            .onChange(of: item.state) { newValue in
                if newValue == .learning {
                    item.nextReviewDate = item.nextReviewDate ?? Date()
                }
            }
            
            if item.state == .learning {
                Picker("Delay", selection: $item.lastBreak) {
                    Text("None")
                        .tag(0)
                    
                    ForEach(Config.reviewTimes, id: \.self) { delay in
                        Text(Date.minutesToShortText(minutes: delay))
                            .tag(delay)
                    }
                }
                .onChange(of: item.lastBreak) { newValue in
                    (_, item.nextReviewDate) = VocabItem.nextBreakAndReviewDate(after: newValue, from: Date(), action: .remain)
                }
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: .constant(VocabList.sample.items[0]))
            .asCard()
    }
}
