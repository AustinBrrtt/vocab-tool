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
}
