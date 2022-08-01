//
//  StatsView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/2/22.
//

import SwiftUI

struct StatsView: View {
    @Binding var vocabList: VocabList
    
    var total: Int {
        vocabList.items.count
    }
    
    var body: some View {
        VStack {
            ForEach([VocabState.mastered, VocabState.learning, VocabState.untouched], id: \.self) { state in
                HStack {
                    StateIcon(state: state)
                    Text(label(for: state))
                        .foregroundColor(color(for: state))
                    Spacer()
                    Text("\(count(for: state))/\(total)")
                    Spacer()
                    Text("\(percentage(for: state))%")
                }
                .foregroundColor(color(for: state))
                .font(.headline)
                .padding()
            }
            Spacer()
        }
        .padding(.horizontal, 40)
        .background(.regularMaterial)
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func count(for state: VocabState) -> Int {
        return vocabList.items.filter({ item in item.state == state }).count
    }
    
    private func percentage(for state: VocabState) -> Int {
        return (100 * count(for: state)) / (total)
    }
    
    private func label(for state: VocabState) -> String {
        return state.rawValue.capitalized
    }
    
    private func color(for state: VocabState) -> Color {
        switch state {
        case .mastered:
            return .yellow
        case .learning:
            return .blue
        case .untouched:
            return .secondary
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(vocabList: .constant(.sample))
    }
}
