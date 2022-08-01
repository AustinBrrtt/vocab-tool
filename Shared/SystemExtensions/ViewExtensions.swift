//
//  ViewExtensions.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

extension View {
    func allowMultiline() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
    
    func asCard(height: CGFloat = 500, onBackgroundTap: @escaping () -> Void = {}) -> some View {
        padding(.horizontal, 2)
            .frame(height: height)
            .background(
                Rectangle()
                    .foregroundColor(Color.background.opacity(0.65))
                    .onTapGesture(perform: onBackgroundTap)
            )
            .cornerRadius(20)
            .shadow(radius: 4)
            .padding()
            .transaction { t in
                t.animation = nil // The card itself can be given a transition in context. Nested transitions can cause buggy-looking behavior.
            }
    }
}
