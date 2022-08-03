//
//  MasterButtonView.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct MasterButtonView: View {
    let master: () -> Void
    
    var body: some View {
        Button(action: master) {
            Label("Mark as Perfected", systemImage: "star.fill")
                .foregroundColor(.background)
                .font(.headline)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.yellow)
                .cornerRadius(5)
        }
        .padding(.leading)
    }
}

struct MasterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MasterButtonView(master: {})
    }
}
