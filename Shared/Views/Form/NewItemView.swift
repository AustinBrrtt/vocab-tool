//
//  NewItemView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vocabList: VocabList
    @State var item = VocabItem(word: "", meaning: "", priority: 0, lastBreak: 0, state: .untouched)
    
    var body: some View {
        VStack {
            Spacer()
            
            EditItemView(item: $item)
            
            Text("Possible Duplicates")
            SearchResults(vocabList: vocabList, wordQuery: item.word, pronunciationQuery: item.pronunciation ?? "", meaningQuery: item.meaning)
            
            Button(action: save) {
                Text("Save New Item")
                    .foregroundColor(.primary)
                    .padding(.horizontal, 50)
                    .padding(.vertical)
                    .background(
                        Rectangle()
                            .foregroundColor(.primary.opacity(0.1))
                            .background(.regularMaterial)
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding()
            
            Spacer()
        }
        .background(.regularMaterial)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: save)
            }
        }
    }
    
    private func save() {
        item.priority = vocabList.items.count + 1
        vocabList.items.append(item)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewItemView_Previews: PreviewProvider {
    struct DummyView: View {
        @State var vl = VocabList.sample
        var body: some View {
            NewItemView(vocabList: $vl)
        }
    }
    static var previews: some View {
        DummyView()
    }
}
