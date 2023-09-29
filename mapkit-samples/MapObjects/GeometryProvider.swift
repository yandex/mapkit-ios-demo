//
//  GeometryProvider.swift
//  MapObjects
//
//  Created by Daniil Pustotin on 31.07.2023.
//

import YandexMapsMobile

enum GeometryProvider {
    static let clusterRadius: CGFloat = 60.0
    static let clusterMinZoom: UInt = 15

    static let startPoint = YMKPoint(latitude: 59.935016, longitude: 30.328903)
    static let startPosition = YMKCameraPosition(target: startPoint, zoom: 15.0, azimuth: .zero, tilt: .zero)

    static let compositeIconPoint = YMKPoint(latitude: 59.939651, longitude: 30.339902)
    static let animatedImagePoint = YMKPoint(latitude: 59.932305, longitude: 30.338758)

    static var circleWithRandomRadius: YMKCircle {
        YMKCircle(center: YMKPoint(latitude: 59.939866, longitude: 30.314352), radius: Float.random(in: 200...600))
    }

    static let polygon: YMKPolygon = {
        var points = [
            (59.935535, 30.326926),
            (59.938961, 30.328576),
            (59.938152, 30.336384),
            (59.934600, 30.335049)
        ]
        .map { YMKPoint(latitude: $0.0, longitude: $0.1) }

        points.append(points[0])
        let outerRing = YMKLinearRing(points: points)

        let innerRing = YMKLinearRing(
            points: [
                (59.936698, 30.331271),
                (59.937495, 30.329910),
                (59.937854, 30.331909),
                (59.937112, 30.333312),
                (59.936698, 30.331271)
            ]
            .map { YMKPoint(latitude: $0.0, longitude: $0.1) }
        )

        return YMKPolygon(outerRing: outerRing, innerRings: [innerRing])
    }()

    static let polyline: YMKPolyline = {
        YMKPolyline(
            points: [
                (59.933475, 30.325256),
                (59.933947, 30.323115),
                (59.935667, 30.324070),
                (59.935901, 30.322370),
                (59.941026, 30.324789)
            ]
            .map { YMKPoint(latitude: $0.0, longitude: $0.1) }
        )
    }()

    static let clusterizedPoints = [
        (59.935535, 30.326926),
        (59.938961, 30.328576),
        (59.938152, 30.336384),
        (59.934600, 30.335049),
        (59.938386, 30.329092),
        (59.938495, 30.330557),
        (59.938854, 30.332325),
        (59.937930, 30.333767),
        (59.937766, 30.335208),
        (59.938203, 30.334316),
        (59.938607, 30.337340),
        (59.937988, 30.337596),
        (59.938168, 30.338533),
        (59.938780, 30.339794),
        (59.939095, 30.338655),
        (59.939815, 30.337967),
        (59.939365, 30.340293),
        (59.935220, 30.333730),
        (59.935792, 30.335223),
        (59.935814, 30.332945)
    ]
    .map { YMKPoint(latitude: $0.0, longitude: $0.1) }
}
