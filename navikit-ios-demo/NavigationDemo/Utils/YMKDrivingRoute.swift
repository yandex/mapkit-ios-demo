//
//  YMKDrivingRoute.swift
//  NavigationDemo
//

import YandexMapsMobile

public extension YMKDrivingRoute {
    var timeWithTraffic: YMKLocalizedValue {
        metadata.weight.timeWithTraffic
    }

    var distanceLeft: YMKLocalizedValue {
        metadata.weight.distance
    }
}
