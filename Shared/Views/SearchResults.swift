//
//  SearchResults.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct SearchResults: View {
    let vocabList: VocabList
    let wordQuery: String
    let pronunciationQuery: String
    let meaningQuery: String
    
    var body: some View {
        List(vocabList.items.filter(filter)) { item in
            HStack {
                Text(item.word)
                    .fontWeight(.heavy)
                if let pronunciation = item.pronunciation {
                    Text("(\(pronunciation))")
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(item.meaning)
            }
//                .padding(.horizontal)
//                .padding(.vertical, 10)
//                .background(Color.background)
//                .cornerRadius(10)
//                .padding()
//                .listRowSeparator(.hidden)
//                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                .background(.regularMaterial)
//                .edgesIgnoringSafeArea(.all)
        }
        .background(.regularMaterial)
        .listStyle(.grouped)
    }
    
    // TODO: Rank results based on if they matched a higher percentage or full word, include if it matches a word (space/punctuation separated) vs just part of a word. e.g. for search term "go", "to go" should rank higher than "goggles" or "gogo gadget arm"
    private func filter(_ item: VocabItem) -> Bool {
        let wordAndPronunciation = "\(item.word) \(item.pronunciation ?? "")".lowercased()
        if wordQuery.count > 0 && wordAndPronunciation.contains(wordQuery.lowercased()) {
            return true
        }
        
        if pronunciationQuery.count > 0 && wordAndPronunciation.contains(pronunciationQuery.lowercased()) {
            return true
        }
        
        
        if meaningQuery.count > 0 && item.meaning.contains(meaningQuery.lowercased()) {
            return true
        }
        
        return false
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(vocabList: .sample, wordQuery: "い", pronunciationQuery: "i", meaningQuery: "super")
    }
}
