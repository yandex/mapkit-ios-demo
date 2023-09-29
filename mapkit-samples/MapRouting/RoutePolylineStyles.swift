//
//  RoutePolylineStyles.swift
//  MapRouting
//
//  Created by Daniil Pustotin on 28.08.2023.
//

import YandexMapsMobile

extension YMKPolylineMapObject {
    func styleMainRoute() {
        zIndex = 10.0
        setStrokeColorWith(.gray)
        strokeWidth = 5.0
        outlineColor = .black
        outlineWidth = 3.0
    }

    func styleAlternativeRoute() {
        zIndex = 5.0
        setStrokeColorWith(.systemTeal)
        strokeWidth = 4.0
        outlineColor = .black
        outlineWidth = 2.0
    }
}
