//
//  CollectionViewCell.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 03.03.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    private var viewModel: EmojiMixViewModel?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize(_ viewModel: EmojiMixViewModel) {
        self.viewModel = viewModel
        setTitleLabel(text: viewModel.emojies)
        setBackgroundColor(viewModel.backgroundColor)
        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$emojies.bind { [weak self] newValue in
            self?.setTitleLabel(text: newValue)
        }

        viewModel.$backgroundColor.bind { [weak self] newValue in
            self?.setBackgroundColor(newValue)
        }
    }

    private func setTitleLabel(text: String?) {
        titleLabel.text = text
    }

    private func setBackgroundColor(_ backgroundColor: UIColor?) {
        contentView.backgroundColor = backgroundColor
    }

    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setupCell() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
