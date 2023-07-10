//
//  ArchiveModels.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import Foundation

enum ArchiveCellType {
    case warningMessage(InformationMessageModel)
    case archiveMessage(ArchiveMessagesModel)
    
    var reusedId: String {
        switch self {
        case .warningMessage:
            return "InformationMessagesCell"
        case .archiveMessage:
            return "ArchiveMessagesCell"
        
        }
    }
}
