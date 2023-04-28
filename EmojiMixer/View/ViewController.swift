//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 03.03.2023.
//

import UIKit

final class ViewController: UIViewController {

    var viewModel: EmojiMixesViewModel?

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
    }

    func initialize(_ viewModel: EmojiMixesViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.onChange = { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setupNavigationController() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                          target: self,
                                          action: #selector(addButtonAction))
        let leftButton = UIBarButtonItem(title: NSLocalizedString("Delete All", comment: ""),
                                         style: .plain,
                                         target: self,
                                         action: #selector(deleteAllButtonAction))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
    }

    @objc private func addButtonAction() {
        viewModel?.addToStoreNewEmojiMix()
    }

    @objc private func deleteAllButtonAction() {
        viewModel?.deleteAllEmojiMixes()
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
                self?.viewModel?.deleteEmojiMixFromStore(at: indexPath)
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.emojiMixes.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell,
              let viewModel = viewModel else { return UICollectionViewCell() }
        cell.initialize(viewModel.emojiMixes[indexPath.item])
        return cell
    }
}
