//
//  Vocab_ToolApp.swift
//  Shared
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI

@main
struct Vocab_ToolApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Vocab_ToolDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
