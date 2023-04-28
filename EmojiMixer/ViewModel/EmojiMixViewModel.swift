//
//  EmojiMixViewModel.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 26.04.2023.
//

import UIKit

@objcMembers
final class EmojiMixViewModel: NSObject, Identifiable {

    dynamic private(set) var emojies: String
    dynamic private(set) var backgroundColor: UIColor

    init(emojies: String, backgroundColor: UIColor) {
        self.emojies = emojies
        self.backgroundColor = backgroundColor
    }
}
