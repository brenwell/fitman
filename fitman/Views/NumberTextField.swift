//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
// sample of input an integer
struct NaturalNumberView: View {
    @State var someNumber: Int = 123

    var body: some View {
        let someNumberProxy = Binding<String>(
            get: { String(format: "%d", Int(self.someNumber)) },
            set: {
                if let value = NumberFormatter().number(from: $0.digits) {
                    let v = value.intValue
                    if (v >= 0) {
                        self.someNumber = value.intValue
                    }
                }
            }
        )

        return VStack {
            TextField("Number", text: someNumberProxy)

            Text("number: \(someNumber)")
        }
      }
}
struct DecimalFieldV2 : View {
    @Binding var value: Double
    @State var displayedText: String? = nil
    @State var lastFormattedValue: Double? = nil
    
    var body: some View {
        let b = Binding<String>(
            get: { return self.displayedText ?? "" },
            set: { newValue in
                self.displayedText = newValue
                if let tmp = NumberFormatter().number(from: newValue)?.doubleValue {
                    self.value = tmp
                }
        })
        
        return TextField("Number", text: b, onEditingChanged: { inFocus in
            if !inFocus {
                self.lastFormattedValue = NumberFormatter().number(from: b.wrappedValue)?.doubleValue
                if self.lastFormattedValue != nil {
                        b.wrappedValue = String(describing: self.lastFormattedValue)
                        
                }
            }
        })
    }
}


struct DecimalView: View {
    @State var someNumber = 123.0

    var someNumberProxy: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.someNumber)) },
            set: {
                if let value = NumberFormatter().number(from: $0.digits) {
                    self.someNumber = value.doubleValue
                }
            }
        )
    }

    var body: some View {
        VStack {
            TextField("Number", text: someNumberProxy)

            Text("number: \(someNumber)")
        }
      }
}
struct DecimalIntView: View {
    @State var someNumber = 123

    var someNumberProxy: Binding<String> {
        Binding<String>(
            get: {
                String(format: "%d", Int(self.someNumber))
                
            },
            set: {
                if let value = NumberFormatter().number(from: $0.digits) {
                    self.someNumber = value.intValue
                }
            }
        )
    }

    var body: some View {
        VStack {
            TextField("Number", text: someNumberProxy,
            onEditingChanged: { inFocus in
                if (!inFocus) {
                    self.someNumberProxy.wrappedValue = self.someNumberProxy.wrappedValue.digits
                }
            })
            Text("number: \(someNumber)")
        }
      }
}


//struct NumberTextField: View {
//    @Binding var someNumber: Int
//    @State var displayText: String?
//    var body: some View {
//        var flag: Bool = false
//        self.displayText = ""//\(self.someNumber)"
//        return TextField("", text: self.displayText, onEditingChanged: {
//            print("onEditChange \($0)")
//            flag = $0
//        }).onReceive(someNumber.publisher.last(), perform: { ch in
//            if(!self.someNumber.isNumber) {
//                let fixit = self.someNumber.digits
//                self.someNumber = fixit
//                buffer = fixit
//            }
//            print("textfield \(ch) \(buffer) \(self.someNumber) \(flag)")
//
//        })
//    }
//}

class HackNumber: ObservableObject {
    @Published var intValue: Int
    @Published var displayText: String {
        didSet {
            if let tmp = NumberFormatter().number(from: self.displayText) {
                self.intValue = tmp.intValue
            }
        }
    }
    init(value: Int) {
        self.intValue = value
        self.displayText = "\(value)"
    }
}

struct NumberTextField: View {
    @Binding var someNumber: String
    var body: some View {
        let label: String = "Number"
        var buffer: String = ""
        return TextField(label, text: $someNumber, onEditingChanged: {
            print("onEditChange \($0)")
        }).onReceive(self.someNumber.publisher.last(), perform: { ch in
            if(!self.someNumber.isNumber) {
                let fixit = self.someNumber.digits
                self.someNumber = fixit
                buffer = fixit
            }
            print("textfield \(ch) \(self.someNumber)")
                    
        })
    }
}

