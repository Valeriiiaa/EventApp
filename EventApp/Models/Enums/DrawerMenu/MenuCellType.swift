//
//  MenuCellType.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import Foundation

enum MenuOptions: String, CaseIterable {
    case home = "Home"
    case askQuestion = "Ask a Question"
    case archive = "Archive"
    case settings = "Settings"
    case logOut = "Log Out"
    
    var imageName: String {
        switch self {
        case .home:
            return "home"
        case .askQuestion:
            return "askQuestion"
        case .archive:
            return "archive"
        case .settings:
            return "settings"
        case .logOut:
            return "logout"
        }
    }
}
