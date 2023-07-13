//
//  StoryboardFabric.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 13.07.2023.
//

import Foundation
import UIKit

class CellManager {
    static func getCell(by name: String) -> String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "\(name)"
            
        default: return "\(name)-iPad"
        }
    }
}

class StoryboardFabric {
    static func getStoryboard(by name: String) -> UIStoryboard {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIStoryboard(name: "\(name)-iphone", bundle: nil)
            
        default: return UIStoryboard(name: "\(name)-ipad", bundle: nil)
        }
    }
}

