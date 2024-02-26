//
//  SettingsSection.swift
//

import Combine

struct SettingItem {
    // MARK: - Public nesting

    enum SettingValue {
        case toggle(CurrentValueSubject<Bool, Never>)
        case float(CurrentValueSubject<Float, Never>)
        case nextScreen(SettingsScreen)
        case dropDown(DropDownValue)
    }

    // MARK: - Public properties

    let title: String
    let value: SettingValue
}

struct SettingsSection {
    // MARK: - Public properties

    let title: String?
    let items: [SettingItem]

    // MARK: - Constructor

    init(title: String? = nil, _ items: [SettingItem]) {
        self.title = title
        self.items = items
    }
}
