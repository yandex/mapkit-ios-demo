//
//  SettingsRepository.swift
//  NavigationDemoApp
//

import Combine
import YandexMapsMobile

enum StyleMode: UInt, Codable, CaseIterable {
    case night
    case day
    case system

    // MARK: - Public properties

    var description: String {
        String(describing: self)
    }
}

enum EcoClass: UInt, Codable, CaseIterable {
    case euro1
    case euro2
    case euro3
    case euro4
    case euro5
    case euro6

    // MARK: - Public properties

    var description: String {
        String(describing: self)
    }
}

enum JamsMode: UInt, Codable, CaseIterable {
    case disabled
    case enabledForCurrentRoute
    case enabled

    // MARK: - Public properties

    var description: String {
        switch self {
        case .enabledForCurrentRoute:
            return "enabled for current route"
        default:
            return String(describing: self)
        }
    }
}

enum AnnotatedEventsType: String, CaseIterable, Codable {
    case manoeuvres
    case fasterAlternative = "faster alternative"
    case roadEvents = "road events"
    case tollRoadAhead = "toll road ahead"
    case speedLimitExceeded = "speed limit exceeded"
    case parkingRoutes = "parking routes"
    case streets
    case routeStatus = "route status"
    case wayPoints = "way points"

    // MARK: - Public properties

    var description: String {
        rawValue
    }

    var annotatedEvent: YMKAnnotatedEvents {
        switch self {
        case .manoeuvres:
            return .manoeuvres

        case .fasterAlternative:
            return .fasterAlternative

        case .roadEvents:
            return .roadEvents

        case .tollRoadAhead:
            return .tollRoadAhead

        case .speedLimitExceeded:
            return .speedLimitExceeded

        case .parkingRoutes:
            return .parkingRoutes

        case .streets:
            return .streets

        case .routeStatus:
            return .routeStatus

        case .wayPoints:
            return .wayPoints
        }
    }
}

enum AnnotatedRoadEventsType: String, CaseIterable, Codable {
    case danger
    case reconstruction
    case accident
    case school
    case overtakingDanger = "overtaking danger"
    case pedestrianDanger = "pedestrian danger"
    case crossRoadDanger = "cross road danger"
    case laneControl = "lane control"
    case roadMarkingControl = "road marking control"
    case crossRoadControl = "cross road control"
    case mobileControl = "mobile control"
    case speedLimitControl = "speed limit control"

    // MARK: - Public properties

    var description: String {
        rawValue
    }

    var annotatedEvent: YMKAnnotatedRoadEvents {
        switch self {
        case .danger:
            return .danger

        case .reconstruction:
            return .reconstruction

        case .accident:
            return .accident

        case .school:
            return .school

        case .overtakingDanger:
            return .overtakingDanger

        case .pedestrianDanger:
            return .pedestrianDanger

        case .crossRoadDanger:
            return .crossRoadDanger

        case .laneControl:
            return .laneControl

        case .roadMarkingControl:
            return .roadMarkingControl

        case .crossRoadControl:
            return .crossRoadControl

        case .mobileControl:
            return .mobileControl

        case .speedLimitControl:
            return .speedLimitControl
        }
    }
}

protocol SettingsRepository {
    // MARK: - Public properties

    var styleMode: CurrentValueSubject<StyleMode, Never> { get }

    // Vehicle options
    var vehicleType: CurrentValueSubject<YMKDrivingVehicleType, Never> { get }
    var weight: CurrentValueSubject<Float, Never> { get }
    var axleWeight: CurrentValueSubject<Float, Never> { get }
    var maxWeight: CurrentValueSubject<Float, Never> { get }
    var height: CurrentValueSubject<Float, Never> { get }
    var width: CurrentValueSubject<Float, Never> { get }
    var length: CurrentValueSubject<Float, Never> { get }
    var payload: CurrentValueSubject<Float, Never> { get }
    var ecoClass: CurrentValueSubject<EcoClass, Never> { get }
    var hasTrailer: CurrentValueSubject<Bool, Never> { get }
    var buswayPermitted: CurrentValueSubject<Bool, Never> { get }

    // Road events
    var roadEventsOnRouteEnabled: CurrentValueSubject<Bool, Never> { get }
    var roadEventsOnRoute: [YMKRoadEventsEventTag: CurrentValueSubject<Bool, Never>] { get }

    // Annotations
    var annotatedEvents: [AnnotatedEventsType: CurrentValueSubject<Bool, Never>] { get }
    var annotatedRoadEvents: [AnnotatedRoadEventsType: CurrentValueSubject<Bool, Never>] { get }
    var annotationLanguage: CurrentValueSubject<YMKAnnotationLanguage, Never> { get }
    var muteAnnotations: CurrentValueSubject<Bool, Never> { get }
    var textAnnotations: CurrentValueSubject<Bool, Never> { get }

    // Driving Options
    var avoidTolls: CurrentValueSubject<Bool, Never> { get }
    var avoidUnpaved: CurrentValueSubject<Bool, Never> { get }
    var avoidPoorConditions: CurrentValueSubject<Bool, Never> { get }

    // Navigation Layer
    var jamsMode: CurrentValueSubject<JamsMode, Never> { get }
    var balloons: CurrentValueSubject<Bool, Never> { get }
    var trafficLights: CurrentValueSubject<Bool, Never> { get }
    var showPredicted: CurrentValueSubject<Bool, Never> { get }
    var balloonsGeometry: CurrentValueSubject<Bool, Never> { get }

    // Camera
    var autoZoom: CurrentValueSubject<Bool, Never> { get }
    var autoRotation: CurrentValueSubject<Bool, Never> { get }
    var autoCamera: CurrentValueSubject<Bool, Never> { get }
    var zoomOffset: CurrentValueSubject<Float, Never> { get }

    // Guidance
    var alternatives: CurrentValueSubject<Bool, Never> { get }
    var simulation: CurrentValueSubject<Bool, Never> { get }
    var simulationSpeed: CurrentValueSubject<Float, Never> { get }
    var background: CurrentValueSubject<Bool, Never> { get }
    var speedLimitTolerance: CurrentValueSubject<Float, Never> { get }
    var restoreGuidanceState: CurrentValueSubject<Bool, Never> { get }
    var serializedNavigation: CurrentValueSubject<String, Never> { get }
}
