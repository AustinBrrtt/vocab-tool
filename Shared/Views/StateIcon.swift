//
//  StateIcon.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/2/22.
//

import SwiftUI

struct StateIcon: View {
    let state: VocabState
    var body: some View {
        switch state {
        case .mastered:
            Image(systemName: "star.circle.fill")
                .foregroundColor(.yellow)
                .background(Color.background.padding(4).cornerRadius(100))
                
        case .learning:
            ZStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                Text("~")
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
            }
        case .untouched:
            ZStack {
                Image(systemName: "ellipsis.circle.fill")
                    .foregroundColor(.gray)
                    .background(Color.white.padding(4).cornerRadius(100))
            }
        }
    }
}

struct StateIcon_Previews: PreviewProvider {
    static var previews: some View {
        StateIcon(state: .mastered)
    }
}
