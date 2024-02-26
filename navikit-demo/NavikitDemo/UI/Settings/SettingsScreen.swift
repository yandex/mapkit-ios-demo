//
//  SettingsScreen.swift
//

import UIKit

enum SettingsScreen {
    case settings
    case vehicleOptions
    case roadEvents
    case roadEventsOnRoute
    case soundAnnotations
    case annotatedEvents
    case drivingOptions
    case camera
    case map
    case simulation
    case guidance

    func createController(with settingsRepository: SettingsRepository) -> UIViewController {
        switch self {
        case .settings:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Settings",
                sections: SettingsScreensSections.settingsSections(settingsRepository: settingsRepository)
            )

        case .vehicleOptions:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Vehicle Options",
                sections: SettingsScreensSections.vehicleOptionsSections(settingsRepository: settingsRepository)
            )

        case .roadEvents:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Road Events",
                sections: SettingsScreensSections.roadEventsSections(settingsRepository: settingsRepository)
            )

        case .roadEventsOnRoute:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Road Events On Route",
                sections: SettingsScreensSections.roadRventsOnRouteSections(settingsRepository: settingsRepository)
            )

        case .soundAnnotations:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Sound Annotations",
                sections: SettingsScreensSections.soundAnnotationsSections(settingsRepository: settingsRepository)
            )

        case .annotatedEvents:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Annotated Events",
                sections: SettingsScreensSections.annotatedEventsSections(settingsRepository: settingsRepository)
            )

        case .drivingOptions:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Driving Options",
                sections: SettingsScreensSections.drivingOptionsSections(settingsRepository: settingsRepository)
            )

        case .camera:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Camera",
                sections: SettingsScreensSections.cameraSections(settingsRepository: settingsRepository)
            )

        case .map:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Map",
                sections: SettingsScreensSections.mapSections(settingsRepository: settingsRepository)
            )

        case .simulation:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Simulation",
                sections: SettingsScreensSections.simulationSections(settingsRepository: settingsRepository)
            )

        case .guidance:
            return SettingsViewController(
                settingsRepository: settingsRepository,
                title: "Guidance",
                sections: SettingsScreensSections.guidanceSections(settingsRepository: settingsRepository)
            )
        }
    }
}
