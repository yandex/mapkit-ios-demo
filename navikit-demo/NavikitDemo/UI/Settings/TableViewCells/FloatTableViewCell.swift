//
//  FloatTableViewCell.swift
//

import Combine
import UIKit

final class FloatTableViewCell: UITableViewCell {
    // MARK: - Public methods

    func setup(with title: String, value: CurrentValueSubject<Float, Never>) {
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

        let number = UILabel()
        number.textColor = tintColor

        value
            .sink { newValue in
                number.text = String((newValue * 100).rounded() / 100)
            }
            .store(in: &cancellablesBag)

        number.translatesAutoresizingMaskIntoConstraints = false
        addSubview(number)

        [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SettingsLayout.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            number.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            number.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: SettingsLayout.height)
        ]
        .forEach { $0.isActive = true }
    }

    // MARK: - Private properties

    private var title: String!
    private var value: CurrentValueSubject<Float, Never>!

    private var cancellablesBag = Set<AnyCancellable>()
}
