//
//  SettingsBinderImpl.swift
//

import Combine
import YandexMapsMobile
import YMKStylingAutomotiveNavigation
import YMKStylingRoadEvents

final class SettingsBinderImpl: SettingsBinder {
    // MARK: - Constructor

    init(
        settingsRepository: SettingsRepository,
        simulationManager: SimulationManager,
        roadEventsLayer: YMKRoadEventsLayer,
        navigationStyleManager: NavigationStyleManager,
        navigationLayer: YMKNavigationLayer,
        navigation: YMKNavigation,
        camera: YMKCamera,
        speaker: Speaker,
        annotationsManager: AnnotationsManager
    ) {
        self.settingsRepository = settingsRepository
        self.simulationManager = simulationManager
        self.roadEventsLayer = roadEventsLayer
        self.navigationStyleManager = navigationStyleManager
        self.navigationLayer = navigationLayer
        self.navigation = navigation
        self.camera = camera
        self.speaker = speaker
        self.annotationsManager = annotationsManager
    }

    // MARK: - Public methods

    func bindSettings() {
        bindSimulationSpeed()
        bindRoadEventsLayer()
        bindNavigationLayer()
        bindNavigation()
        bindspeaker()
        bindAnnotationsManager()
    }

    // MARK: - Private methods

    private func bindSimulationSpeed() {
        settingsRepository.simulationSpeed
            .sink { [weak self] newValue in
                self?.simulationManager.setSpeed(with: Double(newValue))
            }
            .store(in: &cancellablesBag)
    }

    private func bindRoadEventsLayer() {
        settingsRepository.roadEventsOnRoute
            .forEach { tag, value in
                value
                    .sink { [weak self] newValue in
                        self?.roadEventsLayer.setRoadEventVisibleOnRouteWith(tag, on: newValue)
                    }
                    .store(in: &cancellablesBag)
            }
    }

    private func bindNavigationLayer() {
        Publishers.CombineLatest4(
            settingsRepository.jamsMode,
            settingsRepository.balloons,
            settingsRepository.roadEventsOnRouteEnabled,
            Publishers.CombineLatest(
                settingsRepository.trafficLights,
                settingsRepository.showPredicted
            )
            .eraseToAnyPublisher()
        )
        .eraseToAnyPublisher()
        .sink { [weak self] jamsMode, balloons, roadEventsOnRouteEnabled, arg3 in
            let (trafficLights, showPredicted) = arg3
            self?.navigationStyleManager.currentJamsMode = jamsMode
            self?.navigationStyleManager.balloonsVisibility = balloons
            self?.navigationStyleManager.roadEventsOnRouteVisibility = roadEventsOnRouteEnabled
            self?.navigationStyleManager.trafficLightsVisibility = trafficLights
            self?.navigationStyleManager.predictedVisibility = showPredicted

            self?.navigationLayer.refreshStyle()
        }
        .store(in: &cancellablesBag)

        settingsRepository.balloonsGeometry
            .sink { [weak self] newValue in
                self?.navigationLayer.setShowBalloonsGeometryWithEnabled(newValue)
            }
            .store(in: &cancellablesBag)
    }

    private func bindNavigation() {
        settingsRepository.annotationLanguage
            .sink { [weak self] newValue in
                self?.navigation.annotationLanguage = newValue
            }
            .store(in: &cancellablesBag)

        settingsRepository.alternatives
            .sink { [weak self] newValue in
                self?.navigation.guidance.isEnableAlternatives = newValue
            }
            .store(in: &cancellablesBag)

        settingsRepository.speedLimitTolerance
            .sink { [weak self] newValue in
                self?.navigation.guidance.speedLimitTolerance = Double(newValue)
            }
            .store(in: &cancellablesBag)

        Publishers.CombineLatest3(
            settingsRepository.avoidTolls,
            settingsRepository.avoidUnpaved,
            settingsRepository.avoidPoorConditions
        )
        .sink { [weak self] avoidTolls, avoidUnpaved, avoidPoorConditions in
            self?.navigation.isAvoidTolls = avoidTolls
            self?.navigation.isAvoidUnpaved = avoidUnpaved
            self?.navigation.isAvoidPoorConditions = avoidPoorConditions
        }
        .store(in: &cancellablesBag)
    }

    private func bindCamera() {
        Publishers.CombineLatest4(
            settingsRepository.autoCamera,
            settingsRepository.autoRotation,
            settingsRepository.autoZoom,
            settingsRepository.zoomOffset
        )
        .sink { [weak self] autoCamera, autoRotation, autoZoom, zoomOffset in
            self?.camera.isSwitchModesAutomatically = autoCamera
            self?.camera.setAutoRotationWithEnabled(autoRotation, animation: .default)
            self?.camera.setAutoZoomWithEnabled(autoZoom, animation: .default)
            self?.camera.setFollowingModeZoomOffsetWithOffset(zoomOffset, animation: .default)
        }
        .store(in: &cancellablesBag)
    }

    private func bindspeaker() {
        settingsRepository.annotationLanguage
            .sink { [weak self] newValue in
                self?.speaker.setLanguage(with: newValue)
            }
            .store(in: &cancellablesBag)
    }

    private func bindAnnotationsManager() {
        settingsRepository.annotatedEvents
            .forEach { tag, value in
                value
                    .sink { [weak self] newValue in
                        self?.annotationsManager.setAnnotatedEventEnabled(event: tag, isEnabled: newValue)
                    }
                    .store(in: &cancellablesBag)
            }

        settingsRepository.annotatedRoadEvents
            .forEach { tag, value in
                value
                    .sink { [weak self] newValue in
                        self?.annotationsManager.setAnnotatedRoadEventEnabled(event: tag, isEnabled: newValue)
                    }
                    .store(in: &cancellablesBag)
            }

        settingsRepository.muteAnnotations
            .sink { [weak self] newValue in
                self?.annotationsManager.setAnnotationsEnabled(isEnabled: !newValue)
            }
            .store(in: &cancellablesBag)
    }

    // MARK: - Private properties

    private let settingsRepository: SettingsRepository
    private let simulationManager: SimulationManager
    private let roadEventsLayer: YMKRoadEventsLayer
    private let navigationStyleManager: NavigationStyleManager
    private let navigationLayer: YMKNavigationLayer
    private let navigation: YMKNavigation
    private let camera: YMKCamera
    private let speaker: Speaker
    private let annotationsManager: AnnotationsManager

    private var cancellablesBag = Set<AnyCancellable>()
}
