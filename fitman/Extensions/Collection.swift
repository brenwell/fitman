//
//  File.swift
//  fitman
//
//  Created by Brendon Blackwell on 26.01.20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
