//
//  DropDownTableViewCell.swift
//

import Combine
import UIKit

final class DropDownTableViewCell: UITableViewCell {
    // MARK: - Public methods

    func setup(with title: String, value: DropDownValue) {
        self.title = title
        self.value = value

        selectionStyle = .none

        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        let label = UILabel()
        label.text = title

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let picker = UILabel()
        picker.textColor = .tintColor

        value
            .selected
            .sink { [weak self] index in
                picker.text = self?.value.options[Int(index)]
            }
            .store(in: &cancellablesBag)

        picker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picker)

        [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SettingsLayout.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            picker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: SettingsLayout.height)
        ]
        .forEach { $0.isActive = true }
    }

    // MARK: - Private properties

    private var title: String!
    private var value: DropDownValue!

    private var cancellablesBag = Set<AnyCancellable>()
}
