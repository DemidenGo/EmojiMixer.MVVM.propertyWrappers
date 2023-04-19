//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 03.03.2023.
//

import UIKit

final class ViewController: UIViewController {

    lazy var emojiMixFactory = EmojiMixFactory()
    lazy var emojiMixStore = EmojiMixStore()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupConstraints()
        emojiMixStore.delegate = self
    }

    private func setupNavigationController() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                          target: self,
                                          action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func addButtonAction() {
        let newEmojiMix = createViewModel()
        addToStore(newEmojiMix)
    }

    private func addToStore(_ newEmojiMix: EmojiMix) {
        do { try emojiMixStore.addEmojiMix(newEmojiMix) }
        catch { preconditionFailure("Error: \(error.localizedDescription)") }
    }

    private func deleteFromStore(at indexPath: IndexPath) {
        do { try emojiMixStore.deleteEmojiMix(at: indexPath) }
        catch { preconditionFailure("Error: \(error.localizedDescription)") }
    }

    private func createViewModel() -> EmojiMix {
        let emojies = emojiMixFactory.makeNewMix()
        let color = emojiMixFactory.makeColor()
        return EmojiMix(emojies: emojies, backgroundColor: color)
    }

    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider:  { actions in
            return UIMenu(children: [UIAction(title: "Delete") { [weak self] _ in
                self?.deleteFromStore(at: indexPath)
            }])
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 30) / 2, height: (collectionView.bounds.width - 30) / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiMixStore.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiMixStore.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell,
              let emojiMix = emojiMixStore.object(at: indexPath) else { return UICollectionViewCell() }
        cell.setTitleLabel(text: emojiMix.emojies)
        cell.contentView.backgroundColor = emojiMix.backgroundColor
        return cell
    }
}

// MARK: - EmojiMixStoreDelegate

extension ViewController: EmojiMixStoreDelegate {

    func didUpdate(_ insertedIndexes: IndexSet, _ deletedIndexes: IndexSet) {
        let insertedIndexPaths = insertedIndexes.map { IndexPath(item: $0, section: 0) }
        let deletedIndexPaths = deletedIndexes.map { IndexPath(item: $0, section: 0) }
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: insertedIndexPaths)
            collectionView.deleteItems(at: deletedIndexPaths)
        }
    }
}
