//
//  MirroredTextField.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 8/3/22.
//

import SwiftUI

struct MirroredTextField: View {
    @Binding var source: String
    @State var mirror: String
    
    let title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._source = text
        self._mirror = State<String>(initialValue: text.wrappedValue)
    }
    
    var body: some View {
        TextField(title, text: $mirror)
            .onAppear {
                mirror = source
            }
            .onChange(of: mirror) { newValue in
                source = mirror
            }
    }
}

struct MirroredTextField_Previews: PreviewProvider {
    struct WrapperView: View {
        @State var text = "foo"
        
        var body: some View {
            VStack {
                Text(text)
                    .border(.green)
                MirroredTextField("Value", text: $text)
                    .border(.blue)
            }
            .padding()
        }
    }
    static var previews: some View {
        WrapperView()
    }
}
