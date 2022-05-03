//
//  Cache.swift
//  Vocab Tool (iOS)
//
//  Created by Austin Barrett on 5/3/22.
//

import Foundation

class Cache<Element: Equatable> {
    private var elements: [Element] = []
    private var nextIndex: Int = 0
    private var size: Int
    
    init(size: Int) {
        self.size = size
        elements.reserveCapacity(size)
    }
    
    public func remember(_ element: Element) {
        if contains(element) {
            return
        }
        
        if elements.count < size {
            elements.append(element)
        } else {
            elements[nextIndex] = element
            nextIndex = (nextIndex + 1) % size
        }
    }
    
    public func contains(_ element: Element) -> Bool {
        return elements.contains(element)
    }
}
