//
//  ContentView.swift
//  Shared
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

struct ContentView: View {
    @State var showToast = false
    @State var toastMessage = ""
    @State var toastColor = Color.accentColor
    @State var lastToast = UUID()
    @Binding var document: Vocab_ToolDocument

    var body: some View {
        ZStack {
            NavigationView {
                ReviewView(document: $document, toastMessage: $toastMessage, toastColor: $toastColor)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink("Vocab List") {
                                VocabListView(vocabList: $document.vocabList, toastMessage: $toastMessage, toastColor: $toastColor)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            VStack {
                if showToast {
                    Text(toastMessage)
                        .foregroundColor(.background)
                        .padding()
                        .background(toastColor)
                        .cornerRadius(25)
                        .padding()
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
        }
        .onChange(of: toastMessage) { _ in
            if (toastMessage.isEmpty) {
                showToast = false // No animation
            } else {
                let thisToast = UUID()
                withAnimation {
                    showToast = true
                    lastToast = thisToast
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if lastToast == thisToast {
                        withAnimation {
                            showToast = false
                        }
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
