//
//  SimulationManagerImpl.swift
//

import Combine
import YandexMapsMobile

final class SimulationManagerImpl: NSObject, SimulationManager, YMKLocationSimulatorListener {
    // MARK: - Public properties

    var simulationFinished = PassthroughSubject<Void, Never>()

    var isSimulationActive = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Constructor

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    // MARK: - Public methods

    func start(route: YMKDrivingRoute) {
        self.speed = Double(settingsRepository.simulationSpeed.value)

        locationSimulator = YMKMapKit.sharedInstance().createLocationSimulator()
        locationSimulator.subscribeForSimulatorEvents(with: self)
        
        let locationSettings = YMKLocationSettingsFactory.coarseSettings()
        locationSettings.speed = speed
        let simulationSettings =
            [YMKSimulationSettings(geometry: route.geometry, locationSettings: locationSettings)]
        YMKMapKit.sharedInstance().setLocationManagerWith(locationSimulator)

        locationSimulator.startSimulation(withSettings: simulationSettings)
        isSimulationActive.send(true)
    }

    func onSimulationFinished() {
        stop()
    }

    func stop() {
        locationSimulator?.unsubscribeFromSimulatorEvents(with: self)
        locationSimulator = nil
        YMKMapKit.sharedInstance().resetLocationManagerToDefault()
        isSimulationActive.send(false)
        simulationFinished.send(())
    }

    func resume() {
        locationSimulator?.resume()
    }

    func suspend() {
        locationSimulator?.suspend()
    }

    func setSpeed(with speed: Double) {
        self.speed = speed
        locationSimulator?.speed = speed
    }

    // MARK: - Private properties

    private var speed: Double = 20.0

    private var locationSimulator: YMKLocationSimulator!

    private let settingsRepository: SettingsRepository
}
