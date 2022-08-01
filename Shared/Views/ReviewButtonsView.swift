//
//  ReviewButtonsView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct ReviewButtonsView: View {
    let review: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 1.5) {
            Button(action: {
                review(false)
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "multiply")
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color.red)
            .ignoresSafeArea()
            
            Button(action: {
                review(true)
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color.green)
            .ignoresSafeArea()
        }
        .padding(.top, 1.5)
        .background(Color.primary)
        .font(.system(size: 80))
        .ignoresSafeArea()
    }
}

struct ReviewButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewButtonsView(review: { _ in })
    }
}
