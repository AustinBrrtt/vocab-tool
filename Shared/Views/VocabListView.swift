//
//  VocabListView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct VocabListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.editMode) var editMode
    @Binding var vocabList: VocabList
    @State var shownCard: Int = 0
    @State var cardShown: Bool = false
    @State var showCardReverse: Bool = true
    
    var isEditMode: Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        ZStack {
            List($vocabList.items.indices, id: \.self) { idx in
                VocabItemView(vocabItem: $vocabList.items[idx], index: idx, showCard: showCard)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(.regularMaterial)
                    .cornerRadius(15)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if cardShown {
                        EditButton()
                    } else {
                        NavigationLink("Statistics") {
                            StatsView(vocabList: $vocabList)
                        }
                    }
                }
            }
            
            if cardShown {
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .background(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.linear.speed(3)) {
                            if !isEditMode {
                                cardShown = false
                            }
                        }
                    }
                    .transition(.opacity)
                
                if isEditMode {
                    EditItemView(item: $vocabList.items[shownCard])
                } else {
                    FlashCardView(showReverse: $showCardReverse, item: vocabList.items[shownCard], isCompletionPlaceholder: false)
                        .transition(.opacity)
                }
            }
        }
    }
    
    func showCard(_ index: Int) -> Void {
        shownCard = index
        showCardReverse = true
        
        withAnimation(.linear.speed(5)) {
            cardShown = true
        }
    }
}

struct VocabListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VocabListView(vocabList: .constant(.sample))
            VocabListView(vocabList: .constant(.sample))
                .preferredColorScheme(.dark)
        }
    }
}
