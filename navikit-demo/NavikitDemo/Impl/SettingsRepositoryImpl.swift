//
//  SettingsRepositoryImpl.swift
//

import Combine
import YandexMapsMobile

extension YMKDrivingVehicleType: Codable {}
extension YMKAnnotationLanguage: Codable {}

class SettingsRepositoryImpl: SettingsRepository {
    var styleMode: CurrentValueSubject<StyleMode, Never> = setting("styleMode", .system)

    // Vehicle options
    var vehicleType: CurrentValueSubject<YMKDrivingVehicleType, Never> = setting("vehicleType", .default)
    var weight: CurrentValueSubject<Float, Never> = setting("weight", 10.0)
    var axleWeight: CurrentValueSubject<Float, Never> = setting("axleWeight", 5.0)
    var maxWeight: CurrentValueSubject<Float, Never> = setting("maxWeight", 10.0)
    var height: CurrentValueSubject<Float, Never> = setting("height", 3.5)
    var width: CurrentValueSubject<Float, Never> = setting("width", 2.2)
    var length: CurrentValueSubject<Float, Never> = setting("length", 8.0)
    var payload: CurrentValueSubject<Float, Never> = setting("payload", 7.0)
    var ecoClass: CurrentValueSubject<EcoClass, Never> = setting("ecoClass", .euro4)
    var hasTrailer: CurrentValueSubject<Bool, Never> = setting("hasTrailer", false)
    var buswayPermitted: CurrentValueSubject<Bool, Never> = setting("buswayPermitted", false)

    // Road events
    var roadEventsOnRouteEnabled: CurrentValueSubject<Bool, Never> = setting("roadEventsOnRouteEnabled", true)
    var roadEventsOutsideRouteEnabled: CurrentValueSubject<Bool, Never> = setting(
        "roadEventsOutsideRouteEnabled",
        false
    )
    var roadEventsOnRoute: [YMKRoadEventsEventTag: CurrentValueSubject<Bool, Never>] = {
        Dictionary(
            uniqueKeysWithValues: YMKRoadEventsEventTag.allCases.map { tag in
                (tag, setting("roadEventsOnRoute_\(tag.rawValue)", true))
            }
        )
    }()
    var roadEventsOnLayer: [YMKRoadEventsEventTag: CurrentValueSubject<Bool, Never>] = {
        Dictionary(
            uniqueKeysWithValues: YMKRoadEventsEventTag.allCases.map { tag in
                (tag, setting("roadEventsOnLayerSettings_\(tag.rawValue)", true))
            }
        )
    }()

    // Annotations
    var annotatedEvents: [AnnotatedEventsType: CurrentValueSubject<Bool, Never>] = {
        Dictionary(
            uniqueKeysWithValues: AnnotatedEventsType.allCases.map { tag in
                (tag, setting("annotatedEvents_\(tag.rawValue)", true))
            }
        )
    }()
    var annotatedRoadEvents: [AnnotatedRoadEventsType: CurrentValueSubject<Bool, Never>] = {
        Dictionary(
            uniqueKeysWithValues: AnnotatedRoadEventsType.allCases.map { tag in
                (tag, setting("annotatedRoadEvents_\(tag.rawValue)", true))
            }
        )
    }()
    var annotationLanguage: CurrentValueSubject<YMKAnnotationLanguage, Never> = setting("annotationLanguage", .russian)
    var muteAnnotations: CurrentValueSubject<Bool, Never> = setting("muteAnnotations", false)
    var textAnnotations: CurrentValueSubject<Bool, Never> = setting("textAnnotations", true)

    // Driving Options
    var avoidTolls: CurrentValueSubject<Bool, Never> = setting("avoidTolls", false)
    var avoidUnpaved: CurrentValueSubject<Bool, Never> = setting("avoidUnpaved", false)
    var avoidPoorConditions: CurrentValueSubject<Bool, Never> = setting("avoidPoorConditions", false)

    // Navigation Layer
    var jamsMode: CurrentValueSubject<JamsMode, Never> = setting("jamsMode", .enabledForCurrentRoute)
    var balloons: CurrentValueSubject<Bool, Never> = setting("balloons", true)
    var trafficLights: CurrentValueSubject<Bool, Never> = setting("trafficLights", true)
    var showPredicted: CurrentValueSubject<Bool, Never> = setting("showPredicted", false)
    var balloonsGeometry: CurrentValueSubject<Bool, Never> = setting("balloonsGeometry", false)

    // Camera
    var autoZoom: CurrentValueSubject<Bool, Never> = setting("autoZoom", true)
    var autoRotation: CurrentValueSubject<Bool, Never> = setting("autoRotation", true)
    var autoCamera: CurrentValueSubject<Bool, Never> = setting("autoCamera", true)
    var zoomOffset: CurrentValueSubject<Float, Never> = setting("zoomOffset", .zero)

    // Guidance
    var alternatives: CurrentValueSubject<Bool, Never> = setting("alternatives", true)
    var simulation: CurrentValueSubject<Bool, Never> = setting("simulation", true)
    var simulationSpeed: CurrentValueSubject<Float, Never> = setting("simulationSpeed", 20.0)
    var background: CurrentValueSubject<Bool, Never> = setting("background", true)
    var speedLimitTolerance: CurrentValueSubject<Float, Never> = setting("speedLimitTolerance", 0.8)
    var restoreGuidanceState: CurrentValueSubject<Bool, Never> = setting("restoreGuidanceState", true)
    var serializedNavigation: CurrentValueSubject<String, Never> = setting("serializedNavigation", "")

    // MARK: - Private methods

    private static func setting<T: Codable>(_ key: String, _ defaultValue: T) -> CurrentValueSubject<T, Never> {
        var value = defaultValue
        if let data = storage.data(forKey: key),
           let object = try? JSONDecoder().decode(T.self, from: data) {
            value = object
        }

        let subject = CurrentValueSubject<T, Never>(value)

        subject
            .sink { value in
                storage.setValue(try! JSONEncoder().encode(value), forKey: key)
            }
            .store(in: &cancellablesBag)

        return subject
    }

    private static let storage = UserDefaults.standard
    private static var cancellablesBag = Set<AnyCancellable>()
}
