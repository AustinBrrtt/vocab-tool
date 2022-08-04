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
    @Binding var toastMessage: String
    @Binding var toastColor: Color
    
    @State var item = VocabItem(word: "", meaning: "", priority: 0, lastBreak: 0, state: .untouched)
    
    var body: some View {
        VStack {
            Spacer()
            
            EditItemView(item: $item)
            
            Text("Possible Duplicates")
            SearchResults(vocabList: vocabList, wordQuery: item.word, pronunciationQuery: item.pronunciation ?? "", meaningQuery: item.meaning, context: .duplicateSearch) { item in
                if item.state == .untouched,
                   let idx = vocabList.items.firstIndex(where: { $0.id == item.id })
                {
                    vocabList.items[idx].state = .learning
                }
            }
            
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
    
    private func validate() -> Bool {
        if (item.word.isEmpty) {
            sendToast("Word cannot be empty", color: .red)
            return false
        }
        
        if (item.meaning.isEmpty) {
            sendToast("Meaning cannot be empty", color: .red)
            return false
        }
        
        return true
    }
    
    private func save() {
        if (validate()) {
            item.priority = vocabList.items.count + 1
            vocabList.items.append(item)
            sendToast("Added \(item.word)", color: .green)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func sendToast(_ message: String, color: Color) -> Void {
        toastColor = color
        
        // Clear out in case message was same as last time to still trigger change
        toastMessage = ""
        
        // Need slight delay so change is detected separately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toastMessage = message
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    struct DummyView: View {
        @State var vl = VocabList.sample
        var body: some View {
            NewItemView(vocabList: $vl, toastMessage: .constant(""), toastColor: .constant(.green))
        }
    }
    static var previews: some View {
        DummyView()
    }
}
