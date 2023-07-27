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
    
    var description: String {
        switch self {
        case .home:
            return "home".localized
        case .askQuestion:
            return "askQestion".localized
        case .archive:
            return "archive".localized
        case .settings:
            return "settings".localized
        case .logOut:
            return "logOut".localized
        }
    }
    
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
