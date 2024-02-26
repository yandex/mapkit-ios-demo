//
//  SettingsViewController.swift
//

import Combine
import UIKit
import YandexMapsMobile

final class SettingsViewController: UIViewController {
    // MARK: - Constructor

    init(
        settingsRepository: SettingsRepository,
        title navigationTitle: String,
        sections: [SettingsSection]
    ) {
        self.settingsRepository = settingsRepository
        self.navigationTitle = navigationTitle
        self.sections = sections

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

        registerCells()

        updateLayout(with: self.view.frame.size)

        setupSubviews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateLayout(with: size)
        }, completion: nil)
    }

    // MARK: - Private methods

    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect(origin: .zero, size: size)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
    }

    private func registerCells() {
        tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleTableViewCell")
        tableView.register(NextScreenTableViewCell.self, forCellReuseIdentifier: "NextScreenTableViewCell")
        tableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "DropDownTableViewCell")
        tableView.register(FloatTableViewCell.self, forCellReuseIdentifier: "FloatTableViewCell")
    }

    // MARK: - Private propeties

    private let settingsRepository: SettingsRepository

    private let tableView = UITableView()

    private let navigationTitle: String
    private let sections: [SettingsSection]
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.item]

        switch item.value {
        case .nextScreen:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "NextScreenTableViewCell",
                for: indexPath
            ) as! NextScreenTableViewCell
            cell.setup(with: item.title)
            return cell

        case .toggle(let setting):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ToggleTableViewCell",
                for: indexPath
            ) as! ToggleTableViewCell
            cell.setup(with: item.title, setting: setting)
            return cell

        case .dropDown(let value):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DropDownTableViewCell",
                for: indexPath
            ) as! DropDownTableViewCell
            cell.setup(with: item.title, value: value)
            return cell

        case .float(let setting):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FloatTableViewCell",
                for: indexPath
            ) as! FloatTableViewCell
            cell.setup(with: item.title, value: setting)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]

        switch item.value {
        case .nextScreen(let nextScreen):
            navigationController?.pushViewController(
                nextScreen.createController(with: settingsRepository),
                animated: true
            )

        case .toggle(let setting):
            setting.send(!setting.value)

        case .dropDown(let value):
            let actions = value.options.enumerated().map { offset, option in
                UIAlertAction(title: option.capitalized, style: .default) { _ in
                    value.onSelect(offset)
                }
            } + [UIAlertAction(title: "Cancel", style: .cancel)]
            let alert = AlertFactory.make(with: "Choose an option", actions: actions)
            AlertPresenter(controller: self).present(alert: alert)

        case .float(let setting):
            let alert = AlertFactory.makeWithTextField(with: "Set value for \(item.title)") { newValue in
                setting.send(newValue)
            }
            AlertPresenter(controller: self).present(alert: alert)
        }
    }
}
