//
//  EmojiMixViewModel.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 26.04.2023.
//

import UIKit

final class EmojiMixViewModel: NSObject, Identifiable {

    var onChange: (() -> Void)?

    private(set) var emojies: String {
        didSet {
            onChange?()
        }
    }

    private(set) var backgroundColor: UIColor {
        didSet {
            onChange?()
        }
    }

    init(emojies: String, backgroundColor: UIColor) {
        self.emojies = emojies
        self.backgroundColor = backgroundColor
    }
}
