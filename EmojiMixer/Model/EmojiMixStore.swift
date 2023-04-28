//
//  EmojiMixStore.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 17.04.2023.
//

import UIKit
import CoreData

enum EmojiMixStoreError: Error {
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidColorHex
    case hexDeserializationError
}

final class EmojiMixStore: NSObject {

    weak var delegate: EmojiMixStoreDelegate?

    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    private lazy var fetchedResultsController: NSFetchedResultsController<EmojiMixCoreData> = {
        let fetchRequest = EmojiMixCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    var emojiMixes: [EmojiMixCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }

    private func addNewEmojiMix(_ emojiMix: EmojiMix) throws {
        let emojiMixCoreData = EmojiMixCoreData(context: context)
        emojiMixCoreData.emojies = emojiMix.emojies
        let colorHex = UIColorMarshalling.serialize(color: emojiMix.backgroundColor)
        emojiMixCoreData.colorHex = colorHex
        emojiMixCoreData.createdAt = Date()
        try context.save()
    }

    private func deleteEmojiMix(_ emojiMixCoreData: EmojiMixCoreData) throws {
        context.delete(emojiMixCoreData)
        try context.save()
    }

    private func makeEmojiMix(from emojiMixCoreData: EmojiMixCoreData) throws -> EmojiMix {
        guard let emojies = emojiMixCoreData.emojies else {
            throw EmojiMixStoreError.decodingErrorInvalidEmojies
        }
        guard let colorHex = emojiMixCoreData.colorHex else {
            throw EmojiMixStoreError.decodingErrorInvalidColorHex
        }
        guard let color = UIColorMarshalling.deserialize(hexString: colorHex) else {
            throw EmojiMixStoreError.hexDeserializationError
        }
        return EmojiMix(emojies: emojies, backgroundColor: color)
    }

    private func clearUpdatedIndexes() {
        insertedIndexes = nil
        deletedIndexes = nil
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EmojiMixStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateContent()
    }
}

// MARK: - EmojiMixStoreProtocol

extension EmojiMixStore: EmojiMixStoreProtocol {

    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> EmojiMix? {
        let emojiMixCoreData = fetchedResultsController.object(at: indexPath)
        return try? makeEmojiMix(from: emojiMixCoreData)
    }

    func addEmojiMix(_ emojiMix: EmojiMix) throws {
        try? addNewEmojiMix(emojiMix)
    }

    func deleteEmojiMix(at indexPath: IndexPath) throws {
        let emojiMixCoreData = fetchedResultsController.object(at: indexPath)
        try? deleteEmojiMix(emojiMixCoreData)
    }

    func deleteAllObjects() throws {
        let objects = fetchedResultsController.fetchedObjects ?? []
        for object in objects {
            context.delete(object)
        }
        try context.save()
    }
}
