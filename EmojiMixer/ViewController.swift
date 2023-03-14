//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 03.03.2023.
//

import UIKit

final class ViewController: UIViewController {

    private let emojies = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]

    private var visibleEmojies = [String]()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupConstraints()
    }

    private func setupNavigationController() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .undo,
                                         target: self,
                                         action: #selector(removeLastEmoji))
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                          target: self,
                                          action: #selector(addNextEmoji))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
    }

    @objc private func removeLastEmoji() {
//        guard !visibleEmojies.isEmpty else { return }
//        let indexPath = IndexPath(row: visibleEmojies.count - 1, section: 0)
//        let emoji = visibleEmojies.removeLast()
//        emojies.insert(emoji, at: 0)
//        collectionView.performBatchUpdates {
//            collectionView.deleteItems(at: [indexPath])
//        }
        guard visibleEmojies.count > 0 else { return }
        let index = visibleEmojies.count - 1
        let indexPath = IndexPath(row: index, section: 0)
        visibleEmojies.remove(at: index)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [indexPath])
        }
    }

    @objc private func addNextEmoji() {
//        guard !emojies.isEmpty else { return }
//        let emoji = emojies.removeFirst()
//        visibleEmojies.append(emoji)
//        let indexPath = IndexPath(row: visibleEmojies.count - 1, section: 0)
//        collectionView.performBatchUpdates {
//            collectionView.insertItems(at: [indexPath])
//        }
        guard visibleEmojies.count < emojies.count else { return }
        let index = visibleEmojies.count
        let indexPath = IndexPath(row: index, section: 0)
        let emoji = emojies[index]
        visibleEmojies.append(emoji)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [indexPath])
        }
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

    // Для реализации выделения нужно работать с этими методами:

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

    // Реализация контекстного меню:

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        nil
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleEmojies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setTitleLabel(text: visibleEmojies[indexPath.row])
        return cell
    }
}
