//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Lilian Grasset on 16/08/2021.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
