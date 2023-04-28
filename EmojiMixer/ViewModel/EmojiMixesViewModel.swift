//
//  EmojiMixesViewModel.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 26.04.2023.
//

import Foundation

final class EmojiMixesViewModel: NSObject, Identifiable {

    var onChange: (() -> Void)?

    private(set) var emojiMixes: [EmojiMixViewModel] = [] {
        didSet {
            onChange?()
        }
    }

    private let emojiMixFactory: EmojiMixFactory
    private let emojiMixStore: EmojiMixStore

    init(emojiMixFactory: EmojiMixFactory, emojiMixStore: EmojiMixStore) {
        self.emojiMixFactory = emojiMixFactory
        self.emojiMixStore = emojiMixStore
        super.init()
        emojiMixStore.delegate = self
        getEmojiMixesFromStore()
    }

    func addToStoreNewEmojiMix() {
        let newEmojiMix = emojiMixFactory.createEmojiMix()
        do { try emojiMixStore.addEmojiMix(newEmojiMix) }
        catch { preconditionFailure("Error: \(error.localizedDescription)") }
    }

    func deleteEmojiMixFromStore(at indexPath: IndexPath) {
        do { try emojiMixStore.deleteEmojiMix(at: indexPath) }
        catch { preconditionFailure("Error: \(error.localizedDescription)") }
    }

    func deleteAllEmojiMixes() {
        do { try emojiMixStore.deleteAllObjects() }
        catch { preconditionFailure("Error: \(error.localizedDescription)") }
    }

    private func getEmojiMixesFromStore() {
        emojiMixes = emojiMixStore.emojiMixes.map {
            EmojiMixViewModel(
                emojies: $0.emojies ?? "",
                backgroundColor: UIColorMarshalling.deserialize(hexString: $0.colorHex ?? "") ?? .white)
        }
    }
}

// MARK: - EmojiMixStoreDelegate

extension EmojiMixesViewModel: EmojiMixStoreDelegate {

    func didUpdateContent() {
        getEmojiMixesFromStore()
    }
}
