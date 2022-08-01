//
//  FrameSpacer.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/1/22.
//

import SwiftUI

struct FrameSpacer: View {
    let direction: Direction
    
    init(_ direction: Direction) {
        self.direction = direction
    }
    
    var body: some View {
        if direction == .horizontal {
            HStack {}
                .frame(maxWidth: .infinity)
        } else {
            HStack {}
                .frame(maxHeight: .infinity)
        }
    }
    
    enum Direction {
        case horizontal
        case vertical
    }
}
