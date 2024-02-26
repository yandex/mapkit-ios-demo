//
//  NextScreenTableViewCell.swift
//

import Combine
import UIKit

final class NextScreenTableViewCell: UITableViewCell {
    // MARK: - Public methods

    func setup(with title: String) {
        self.title = title

        selectionStyle = .none

        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        let label = UILabel()
        label.text = title

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)

        [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SettingsLayout.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: SettingsLayout.height)
        ]
        .forEach { $0.isActive = true }
    }

    // MARK: - Private properties

    private var title: String!
    private var tapHandler: (() -> Void)!
}
