//
//  StateTransformationIcon.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/3/22.
//

import SwiftUI

struct StateTransformationIcon: View {
    let from: VocabState
    let to: VocabState
    let option = 1
    
    var body: some View {
        switch option {
        case 0:
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.green)
        case 1:
            ZStack {
                StateIcon(state: from)
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 13))
                    .offset(x: 8, y: -8)
            }
//        case 2:
//            ZStack {
//
//                ZStack {
//                    Image(systemName: "arrowshape.turn.up.right.fill")
//                        .foregroundColor(.green)
//                    Image(systemName: "arrowshape.turn.up.right")
//                        .foregroundColor(.primary)
//                        .opacity(0.3)
//                }
//                .font(.system(size: 5))
//                .rotationEffect(.degrees(-30))
//                .offset(x: -10.2, y: -1)
//
//                StateIcon(state: from)
//                    .scaleEffect(x: 0.5, y: 0.5)
//                    .offset(x: -12, y: 5)
//
//                StateIcon(state: to)
//                    .scaleEffect(x: 0.9, y: 0.9)
//                    .offset(y: -1)
//            }
        case 3:
            ZStack {
                ZStack {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .foregroundColor(.green)
                    Image(systemName: "arrowshape.turn.up.left")
                        .foregroundColor(.primary)
                        .opacity(0.3)
                }
                .font(.system(size: 8))
                .rotationEffect(.degrees(105))
                .offset(x: 12.5)

                StateIcon(state: from)

                StateIcon(state: to)
                    .scaleEffect(x: 0.6, y: 0.6)
                    .offset(x: 14, y: -9.5)
            }
        default:
            Text("HI")
        }
    }
}

struct StateTransformationIcon_Previews: PreviewProvider {
    struct Row<Content: View>: View {
        let enabled: Bool
        let content: () -> Content
        
        var body: some View {
            HStack {
                Text("This is some text")
                    .foregroundColor(enabled ? .primary : .secondary)
                Spacer()
                content()
                    .padding(.horizontal)
            }
            .padding()
            .background(enabled ? Color.background.opacity(1) : Color.background.opacity(0.7))
            .padding(.vertical, 5)
        }
    }
    
    struct Wrapper: View {
        let previewContent: [VocabState] = [.mastered, .learning, .untouched, .learning, .learning, .learning, .mastered, .untouched, .untouched, .mastered]
        
        var body: some View {
            VStack {
                Spacer()
                ForEach(previewContent, id: \.self) { c in
                    Row(enabled: c == .untouched) {
                        VStack {
                            if c == .untouched {
                                StateTransformationIcon(from: .untouched, to: .learning)
                            } else {
                                StateIcon(state: c)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
                Spacer()
            }
            .ignoresSafeArea(.all)
            .background(.regularMaterial)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
