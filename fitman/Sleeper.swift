//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
import IOKit.pwr_mgt

var assertionID: IOPMAssertionID = 0
var sleepDisabled = false

func disableScreenSleep(reason: String = "Disabling Screen Sleep") {
//    print("PREVENTING SLEEP")
    sleepDisabled =  IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), reason as CFString, &assertionID) == kIOReturnSuccess
}
func  enableScreenSleep() {
//    print("ALLOWING SLEEP")
    IOPMAssertionRelease(assertionID)
    sleepDisabled = false
}
