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
        padding(.horizontal, 5)
            .frame(height: height)
            .background(
                Rectangle()
                    .foregroundColor(Color.background.opacity(0.65))
                    .onTapGesture(perform: onBackgroundTap)
            )
            .cornerRadius(20)
            .shadow(radius: 4)
            .padding()
    }
    
    func transitionSuddenly(delay: Double?) -> some View {
        var animation: Animation = .linear(duration: 0.01)
        
        if let delay = delay {
            animation = animation.delay(delay)
        }
                                                   
        return transition(.opacity.animation(animation))
    }
    
    func show(if condition: Bool) -> some View {
        if condition {
            return AnyView(self)
        } else {
            return AnyView(EmptyView())
        }
    }
}
