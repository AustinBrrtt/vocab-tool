//
//  Vocab_ToolDocument.swift
//  Shared
//
//  Created by Austin Barrett on 5/1/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var vocabList: UTType {
        UTType(exportedAs: "io.austinbarrett.vocab-tool.list")
    }
}

struct Vocab_ToolDocument: FileDocument {
    var vocabList: VocabList

    init(list: VocabList = VocabList(items: [])) {
        vocabList = list
    }

    static var readableContentTypes: [UTType] { [.vocabList] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        do {
            vocabList = try JSONDecoder().decode(VocabList.self, from: data)
        } catch {
            print(error)
            throw CocoaError(.coderInvalidValue)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let value = try? JSONEncoder().encode(vocabList) else {
            throw CocoaError(.coderInvalidValue)
        }
        return .init(regularFileWithContents: value)
    }
}
