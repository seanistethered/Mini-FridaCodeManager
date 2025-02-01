//
//  Mini_FCMApp.swift
//  Mini FCM
//
//  Created by fridakitten on 04.12.24.
//

import SwiftUI

let isiOS16: Bool = ProcessInfo.processInfo.isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 16, minorVersion: 0, patchVersion: 0))
let isPad: Bool = {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return true
    } else {
        return false
    }
}()

@main
struct Mini_FCMApp: App {
    
    init() {
        UIInit(type: 1)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func gsuffix(from fileName: String) -> String {
    let trimmedFileName = fileName.replacingOccurrences(of: " ", with: "")
    let suffix = URL(string: trimmedFileName)?.pathExtension
    return suffix ?? ""
}
