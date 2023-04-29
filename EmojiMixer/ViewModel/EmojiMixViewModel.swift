//
//  EmojiMixViewModel.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 26.04.2023.
//

import UIKit

final class EmojiMixViewModel: NSObject, Identifiable {

    @Observable
    private(set) var emojies: String

    @Observable
    private(set) var backgroundColor: UIColor

    init(emojies: String, backgroundColor: UIColor) {
        self.emojies = emojies
        self.backgroundColor = backgroundColor
    }
}
