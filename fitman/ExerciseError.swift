//
//  Error.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation
import Cocoa

struct FitmanError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

func exerciseErrorDialog(text: String) {
    let alert = NSAlert()
    alert.messageText = "Error: "
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

func fred() {
    exerciseErrorDialog(text: "This is from fred")
}
