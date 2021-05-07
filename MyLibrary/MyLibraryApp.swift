//
//  MyLibraryApp.swift
//  MyLibrary
//
//  Created by Nadia Seleem on 20/07/1442 AH.
//

import SwiftUI

@main
struct MyLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Library())
        }
    }
}
