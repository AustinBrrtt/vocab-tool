//
//  VocabListView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct VocabListView: View {
    @Binding var vocabList: VocabList
    
    var body: some View {
        List(vocabList.items) { item in
            VocabItemView(vocabItem: item)
        }
    }
}

struct VocabListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabListView(vocabList: .constant(.sample))
    }
}
