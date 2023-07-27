//
//  String+Localization.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 27.07.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
