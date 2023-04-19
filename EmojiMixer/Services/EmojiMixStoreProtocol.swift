//
//  EmojiMixStoreProtocol.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 19.04.2023.
//

import UIKit

protocol EmojiMixStoreProtocol {
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> EmojiMix?
    func addEmojiMix(_ emojiMix: EmojiMix) throws
    func deleteEmojiMix(at indexPath: IndexPath) throws
}
