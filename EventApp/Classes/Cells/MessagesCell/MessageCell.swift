//
//  MessageCell.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 25.08.2023.
//

import Foundation

protocol MessageCell {
    func configure(text: String, time: String)
}
