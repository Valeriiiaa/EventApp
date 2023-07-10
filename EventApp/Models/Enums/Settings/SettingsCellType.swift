//
//  SettingsCellType.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import Foundation

enum SettingsCellType {
    case textField(TextFieldModel)
    case switcher(SwitcherModel)
    
    var reusedId: String {
        switch self {
        case .textField:
            return "CustomFieldCell"
        case .switcher:
            return "SwitcherCell"
        }
    }
}
