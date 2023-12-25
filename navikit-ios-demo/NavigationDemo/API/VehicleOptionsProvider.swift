//
//  VehicleOptionsProvider.swift
//  NavigationDemo
//

import YandexMapsMobile

protocol VehicleOptionsProvider {
    // MARK: - Public properties

    var vehicleOptions: YMKDrivingVehicleOptions { get }
}
