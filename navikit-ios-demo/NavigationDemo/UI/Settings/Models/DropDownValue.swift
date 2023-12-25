//
//  DropDownValue.swift
//  NavigationDemo
//

import Combine
import YandexMapsMobile

struct DropDownValue {
    // MARK: - Public nesting

    enum DropDownType {
        case jams
        case vehicleType
        case ecoClass
        case annotationsLanguage
        case styleMode
    }

    // MARK: - Public properties

    let options: [String]
    let selected: AnyPublisher<UInt, Never>
    let onSelect: (Int) -> Void

    // MARK: - Constructor

    private init(options: [String], selected: AnyPublisher<UInt, Never>, onSelect: @escaping (Int) -> Void) {
        self.options = options
        self.selected = selected
        self.onSelect = onSelect
    }

    init(settingsRepository: SettingsRepository, type: DropDownType) {
        switch type {
        case .jams:
            self = Self(
                options: JamsMode.allCases.map { $0.description.capitalized },
                selected: settingsRepository.jamsMode.map { $0.rawValue }.eraseToAnyPublisher()
            ) { index in
                settingsRepository.jamsMode.send(JamsMode.allCases[index])
            }

        case .vehicleType:
            self = Self(
                options: YMKDrivingVehicleType.allCases.map { $0.description.capitalized },
                selected: settingsRepository.vehicleType.map { $0.rawValue }.eraseToAnyPublisher()
            ) { index in
                settingsRepository.vehicleType.send(YMKDrivingVehicleType.allCases[index])
            }

        case .ecoClass:
            self = Self(
                options: EcoClass.allCases.map { $0.description.capitalized },
                selected: settingsRepository.ecoClass.map { $0.rawValue }.eraseToAnyPublisher()
            ) { index in
                settingsRepository.ecoClass.send(EcoClass.allCases[index])
            }

        case .annotationsLanguage:
            self = Self(
                options: YMKAnnotationLanguage.allCases.map { $0.description.capitalized },
                selected: settingsRepository.annotationLanguage.map { $0.rawValue }.eraseToAnyPublisher()
            ) { index in
                settingsRepository.annotationLanguage.send(YMKAnnotationLanguage.allCases[index])
            }

        case .styleMode:
            self = Self(
                options: StyleMode.allCases.map { $0.description.capitalized },
                selected: settingsRepository.styleMode.map { $0.rawValue }.eraseToAnyPublisher()
            ) { index in
                settingsRepository.styleMode.send(StyleMode.allCases[index])
            }
        }
    }
}
