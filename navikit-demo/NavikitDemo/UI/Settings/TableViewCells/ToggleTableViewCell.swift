//
//  ToggleTableViewCell.swift
//

import Combine
import UIKit

final class ToggleTableViewCell: UITableViewCell {
    // MARK: - Public methods

    func setup(with title: String, setting: CurrentValueSubject<Bool, Never>) {
        self.title = title
        self.setting = setting

        selectionStyle = .none

        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        let label = UILabel()
        label.text = title

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let toggle = UISwitch()

        setting
            .sink { isOn in
                toggle.setOn(isOn, animated: true)
            }
            .store(in: &cancellablesBag)

        toggle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toggle)

        [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SettingsLayout.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SettingsLayout.padding),
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: SettingsLayout.height)
        ]
        .forEach { $0.isActive = true }
    }

    // MARK: - Private properties

    private var title: String!
    private var setting: CurrentValueSubject<Bool, Never>!

    private var cancellablesBag = Set<AnyCancellable>()
}
