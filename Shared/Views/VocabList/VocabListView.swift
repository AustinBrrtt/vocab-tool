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
    @Binding var toastMessage: String
    @Binding var toastColor: Color
    
    @State var shownCard = 0
    @State var cardShown = false
    @State var cardRotation: Double = 0
    @State var searchText = ""
    
    var isEditMode: Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }
    
    var searchResults: [Int] {
        if searchText.isEmpty {
            return Array(vocabList.items.indices)
        } else {
            return vocabList.items.indices.filter { idx in
                let item = vocabList.items[idx]
                let searchSource = "\(item.word) \(item.pronunciation ?? "") \(item.meaning)".lowercased()
                return searchSource.contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ZStack {
            List(searchResults, id: \.self) { idx in
                VocabItemView(vocabItem: $vocabList.items[idx], index: idx, showCard: showCard)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(.regularMaterial)
                    .cornerRadius(15)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: (idx == vocabList.items.count - 1) ? 100 : 10, trailing: 20))
            }
            .searchable(text: $searchText)
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
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: { NewItemView(vocabList: $vocabList, toastMessage: $toastMessage, toastColor: $toastColor) }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green.opacity(0.7))
                            .foregroundStyle(.ultraThinMaterial)
                            .font(.system(size: 50))
                            .background(
                                Rectangle()
                                    .foregroundStyle(.regularMaterial)
                                    .cornerRadius(100)
                                    .padding(4)
                            )
                            .cornerRadius(100)
                    }
                    .padding()
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
                        .asCard()
                } else {
                    FlashCardView(rotation: $cardRotation, item: vocabList.items[shownCard], isCompletionPlaceholder: false)
                        .transition(.opacity)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(cardShown)
    }
    
    func showCard(_ index: Int) -> Void {
        shownCard = index
        cardRotation = 180
        
        withAnimation(.linear.speed(5)) {
            cardShown = true
        }
    }
}

struct VocabListView_Previews: PreviewProvider {
    struct PreviewView: View {
        @State private var navOptions: [String] = ["f"]
        @State private var navStack: [String] = ["f"]
        
        var body: some View {
            NavigationStack(path: $navStack) {
                List(navOptions, id: \.self) { f in
                    NavigationLink(f, value: f)
                }
                .navigationDestination(for: String.self) { _ in
                    VocabListView(vocabList: .constant(.sample), toastMessage: .constant(""), toastColor: .constant(.green))
                }
            }
        }
    }
    static var previews: some View {
        Group {
            PreviewView()
            PreviewView()
                .preferredColorScheme(.dark)
        }
    }
}
