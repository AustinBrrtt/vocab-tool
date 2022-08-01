//
//  FlashCardPickerPreview.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardPickerPreview: View {
    @State var index: Int = 0
    @State var showReverse: Bool
    
    init(showReverse: Bool = false) {
        _showReverse = State<Bool>(initialValue: showReverse)
    }
    
    var body: some View {
        VStack {
            Picker("i", selection: $index) {
                ForEach(VocabList.sample.items.indices, id: \.self) { idx in
                    Text("\(idx): \(VocabList.sample.items[idx].word)").tag(idx)
                }
            }
            .pickerStyle(.wheel)
            
            FlashCardView(showReverse: $showReverse, item:
                            VocabList.sample.items[index], isCompletionPlaceholder: false)
        }
    }
}