//
//  EmojiMixStoreDelegate.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 18.04.2023.
//

import UIKit

protocol EmojiMixStoreDelegate: AnyObject {
    func didUpdate(_ insertedIndexes: IndexSet, _ deletedIndexes: IndexSet)
}
