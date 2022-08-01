//
//  VocabListView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct VocabListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var vocabList: VocabList
    @State var shownCard: VocabItem = VocabItem.placeholderItem
    @State var cardShown: Bool = false
    @State var showCardReverse: Bool = true
    
    var body: some View {
        ZStack {
            List(vocabList.items) { item in
                VocabItemView(vocabItem: item, showCard: showCard)
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
                    NavigationLink("Statistics") {
                        StatsView(vocabList: $vocabList)
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
                            cardShown = false
                        }
                    }
                    .transition(.opacity)
                FlashCardView(showReverse: $showCardReverse, item: shownCard, isCompletionPlaceholder: false)
                    .transition(.opacity)
            }
        }
    }
    
    func showCard(_ item: VocabItem) -> Void {
        shownCard = item
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
