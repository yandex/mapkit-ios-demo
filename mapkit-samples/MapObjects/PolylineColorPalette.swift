//
//  PolylineColorPalette.swift
//  MapObjects
//

import UIKit

enum PolylineColorPalette {
    // MARK: - Public properties

    static var color: UIColor {
        colorIndex = (colorIndex + 1) % colors.count
        return colors[colorIndex]
    }

    // MARK: - Private properties

    private static var colorIndex: Int = 0

    private static let colors: [UIColor] = [
        .blue,
        .purple,
        .orange,
        .green
    ]
}
