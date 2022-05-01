//
//  ContentView.swift
//  Shared
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: Vocab_ToolDocument

    var body: some View {
        NavigationView {
            ReviewView(vocabList: $document.vocabList)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Vocab List") {
                            VocabListView(vocabList: $document.vocabList)
                        }
                    }
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(Vocab_ToolDocument(list: .sample)))
    }
}
