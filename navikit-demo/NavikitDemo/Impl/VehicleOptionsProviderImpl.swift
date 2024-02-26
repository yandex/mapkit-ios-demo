//
//  VehicleOptionsProviderImpl.swift
//

import YandexMapsMobile

final class VehicleOptionsProviderImpl: VehicleOptionsProvider {
    // MARK: - Public properties

    var vehicleOptions: YMKDrivingVehicleOptions {
        if settingsRepository.vehicleType.value == .default {
            return YMKDrivingVehicleOptions()
        }

        return YMKDrivingVehicleOptions(
            vehicleType: settingsRepository.vehicleType.value,
            weight: NSNumber(value: settingsRepository.weight.value),
            axleWeight: NSNumber(value: settingsRepository.axleWeight.value),
            maxWeight: NSNumber(value: settingsRepository.maxWeight.value),
            height: NSNumber(value: settingsRepository.height.value),
            width: NSNumber(value: settingsRepository.width.value),
            length: NSNumber(value: settingsRepository.length.value),
            payload: NSNumber(value: settingsRepository.payload.value),
            ecoClass: NSNumber(value: settingsRepository.ecoClass.value.rawValue),
            hasTrailer: NSNumber(value: settingsRepository.hasTrailer.value),
            buswayPermitted: NSNumber(value: settingsRepository.buswayPermitted.value)
        )
    }
    // MARK: - Constructor

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    // MARK: - Private properties

    private let settingsRepository: SettingsRepository
}
