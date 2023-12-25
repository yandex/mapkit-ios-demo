//
//  SettingsScreensSections.swift
//  NavigationDemo
//

import Foundation
import YandexMapsMobile

enum SettingsScreensSections {
    static func settingsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(title: "Map", value: .nextScreen(.map)),
                    SettingItem(title: "Camera", value: .nextScreen(.camera)),
                    SettingItem(title: "Guidance", value: .nextScreen(.guidance)),
                    SettingItem(title: "Simulation", value: .nextScreen(.simulation))
                ]
            ),
            SettingsSection(
                title: "Events",
                [
                    SettingItem(title: "Road Events", value: .nextScreen(.roadEvents)),
                    SettingItem(title: "Sound Annotations", value: .nextScreen(.soundAnnotations))
                ]
            ),
            SettingsSection(
                title: "Options",
                [
                    SettingItem(title: "Driving options", value: .nextScreen(.drivingOptions)),
                    SettingItem(title: "Vehicle options", value: .nextScreen(.vehicleOptions))
                ]
            )
        ]
    }

    static func mapSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Map Style Mode",
                        value: .dropDown(DropDownValue(settingsRepository: settingsRepository, type: .styleMode))
                    ),
                    SettingItem(
                        title: "Jams Mode",
                        value: .dropDown(DropDownValue(settingsRepository: settingsRepository, type: .jams))
                    )
                ]
            ),
            SettingsSection(
                [
                    SettingItem(
                        title: "Baloons",
                        value: .toggle(settingsRepository.balloons)
                    ),
                    SettingItem(
                        title: "Traffic Lights",
                        value: .toggle(settingsRepository.trafficLights)
                    ),
                    SettingItem(
                        title: "Show Predicted",
                        value: .toggle(settingsRepository.showPredicted)
                    ),
                    SettingItem(
                        title: "Ballons Geometry",
                        value: .toggle(settingsRepository.balloonsGeometry)
                    )
                ]
            )
        ]
    }

    static func cameraSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Auto Camera",
                        value: .toggle(settingsRepository.autoCamera)
                    ),
                    SettingItem(
                        title: "Auto Zoom",
                        value: .toggle(settingsRepository.autoZoom)
                    ),
                    SettingItem(
                        title: "Auto Rotation",
                        value: .toggle(settingsRepository.autoRotation)
                    ),
                    SettingItem(
                        title: "Zoom Offset",
                        value: .float(settingsRepository.zoomOffset)
                    )
                ]
            )
        ]
    }

    static func guidanceSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Speed limit tolerance",
                        value: .float(settingsRepository.speedLimitTolerance)
                    ),
                    SettingItem(
                        title: "Background Guidance",
                        value: .toggle(settingsRepository.background)
                    ),
                    SettingItem(
                        title: "Alternatives",
                        value: .toggle(settingsRepository.alternatives)
                    ),
                    SettingItem(
                        title: "Restore Guidance",
                        value: .toggle(settingsRepository.restoreGuidanceState)
                    )
                ]
            )
        ]
    }

    static func simulationSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Simulation",
                        value: .toggle(settingsRepository.simulation)
                    ),
                    SettingItem(
                        title: "Speed",
                        value: .float(settingsRepository.simulationSpeed)
                    )
                ]
            )
        ]
    }

    static func roadEventsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Show Road Events On Route",
                        value: .toggle(settingsRepository.roadEventsOnRouteEnabled)
                    ),
                    SettingItem(
                        title: "Road Events On Route",
                        value: .nextScreen(.roadEventsOnRoute)
                    )
                ]
            )
        ]
    }

    static func roadRventsOnRouteSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                YMKRoadEventsEventTag.allCases.map { type in
                    SettingItem(
                        title: String(describing: type).capitalized,
                        value: .toggle(settingsRepository.roadEventsOnRoute[type]!)
                    )
                }
            )
        ]
    }

    static func soundAnnotationsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Mute Annotations",
                        value: .toggle(settingsRepository.muteAnnotations)
                    ),
                    SettingItem(
                        title: "Annotation Language",
                        value: .dropDown(
                            DropDownValue(
                                settingsRepository: settingsRepository,
                                type: .annotationsLanguage
                            )
                        )
                    ),
                    SettingItem(
                        title: "Text Annotations",
                        value: .toggle(settingsRepository.textAnnotations)
                    ),
                    SettingItem(
                        title: "Annotated Events",
                        value: .nextScreen(.annotatedEvents)
                    )
                ]
            )
        ]
    }

    static func annotatedEventsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                title: "Annotated Events",
                AnnotatedEventsType.allCases.map { type in
                    SettingItem(
                        title: type.rawValue.capitalized,
                        value: .toggle(settingsRepository.annotatedEvents[type]!)
                    )
                }
            ),
            SettingsSection(
                title: "Annotated Events On Route",
                AnnotatedRoadEventsType.allCases.map { type in
                    SettingItem(
                        title: type.rawValue.capitalized,
                        value: .toggle(settingsRepository.annotatedRoadEvents[type]!)
                    )
                }
            )
        ]
    }

    static func drivingOptionsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Avoid Tolls Routes",
                        value: .toggle(settingsRepository.avoidTolls)
                    ),
                    SettingItem(
                        title: "Avoid Unpaved Routes",
                        value: .toggle(settingsRepository.avoidUnpaved)
                    ),
                    SettingItem(
                        title: "Avoid Poor Conditions Routes",
                        value: .toggle(settingsRepository.avoidPoorConditions)
                    )
                ]
            )
        ]
    }

    static func vehicleOptionsSections(settingsRepository: SettingsRepository) -> [SettingsSection] {
        [
            SettingsSection(
                [
                    SettingItem(
                        title: "Vehicle type",
                        value: .dropDown(DropDownValue(settingsRepository: settingsRepository, type: .vehicleType))
                    ),
                    SettingItem(
                        title: "Weight",
                        value: .float(settingsRepository.weight)
                    ),
                    SettingItem(
                        title: "Axle Weight",
                        value: .float(settingsRepository.axleWeight)
                    ),
                    SettingItem(
                        title: "Max Weight",
                        value: .float(settingsRepository.maxWeight)
                    ),
                    SettingItem(
                        title: "Height",
                        value: .float(settingsRepository.height)
                    ),
                    SettingItem(
                        title: "Width",
                        value: .float(settingsRepository.width)
                    ),
                    SettingItem(
                        title: "Length",
                        value: .float(settingsRepository.length)
                    ),
                    SettingItem(
                        title: "Payload",
                        value: .float(settingsRepository.payload)
                    ),
                    SettingItem(
                        title: "Eco Class",
                        value: .dropDown(DropDownValue(settingsRepository: settingsRepository, type: .ecoClass))
                    ),
                    SettingItem(
                        title: "Has Trailer",
                        value: .toggle(settingsRepository.hasTrailer)
                    ),
                    SettingItem(
                        title: "Busway Permitted",
                        value: .toggle(settingsRepository.buswayPermitted)
                    )
                ]
            )
        ]
    }
}
