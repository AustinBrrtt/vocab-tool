//
//  FlashCardPickerPreview.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FlashCardPickerPreview: View {
    @State var index: Int = 0
    @State var rotation: Double
    
    init(showReverse: Bool = false) {
        _rotation = State<Double>(initialValue: showReverse ? 180 : 0)
    }
    
    var body: some View {
        VStack {
            Picker("i", selection: $index) {
                ForEach(VocabList.sample.items.indices, id: \.self) { idx in
                    Text("\(idx): \(VocabList.sample.items[idx].word)").tag(idx)
                }
            }
            .pickerStyle(.wheel)
            
            FlashCardView(rotation: $rotation, item:
                            VocabList.sample.items[index], isCompletionPlaceholder: false)
        }
    }
}
