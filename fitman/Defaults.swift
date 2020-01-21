//
//  Defaults.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/14/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static var sessionKey: String = "fitman_sessionKey"
    static var preludeDelay: String  = "fitman_preludeDelay"
    static var layoutId: String  = "fitman_layoutId"
}

enum LayoutIds: String {
    case ring = "ring"
    case disk = "disk"
}
// An observable class to hold values of user defaults and keep those values in
// sync with the UserDefaults store.
// Contains a hack to overcome bug with TextField and NumberFormatter - thats why preludeDelayString exists
class Defaults: ObservableObject {
    var selectedSessionKey: String {
        didSet {
            UserDefaults.standard.set(self, forKey: UserDefaultKeys.sessionKey)
        }
    }
    var preludeDelayString: String {
        didSet {
            if let tmp = NumberFormatter().number(from: self.preludeDelayString) {
                self.preludeDelay = tmp.intValue
            }
        }
    }
    var preludeDelay: Int {
           didSet {
               UserDefaults.standard.set(self, forKey: UserDefaultKeys.preludeDelay)
           }
       }
//    var layoutId: LayoutIds {
//           didSet {
//               UserDefaults.standard.set(self, forKey: UserDefaultKeys.layoutId)
//           }
//       }
    private static var sharedDefaults: Defaults = Defaults()
    
    private init() {
        if let tmp = UserDefaults.standard.object(forKey: UserDefaultKeys.sessionKey) as! String? {
            self.selectedSessionKey = tmp
        } else {
            self.selectedSessionKey = ""
        }

        if let tmp = UserDefaults.standard.object(forKey: UserDefaultKeys.preludeDelay) as! Int? {
            self.preludeDelay = tmp
        } else {
            self.preludeDelay = 10
        }
        self.preludeDelayString = String(self.preludeDelay)

//        if let tmp = UserDefaults.standard.object(forKey: UserDefaultKeys.sessionKey) as! LayoutIds? {
//            self.layoutId = tmp
//        } else {
//            self.layoutId = LayoutIds.ring
//        }
    }
    class func shared() -> Defaults {
        return sharedDefaults
    }
}
