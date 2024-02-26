//
//  VehicleOptionsProvider.swift
//

import YandexMapsMobile

protocol VehicleOptionsProvider {
    // MARK: - Public properties

    var vehicleOptions: YMKDrivingVehicleOptions { get }
}
