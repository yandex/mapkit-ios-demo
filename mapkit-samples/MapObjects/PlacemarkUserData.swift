//
//  PlacemarkUserData.swift
//  MapObjects
//
//  Created by Daniil Pustotin on 03.08.2023.
//

import UIKit

enum PlacemarkType: CaseIterable {
    case green
    case yellow
    case red

    static var random: Self {
        [.green, .yellow, .red].randomElement() ?? .green
    }

    var image: UIImage {
        switch self {
        case .green:
            return UIImage(named: "pin_green")!

        case .yellow:
            return UIImage(named: "pin_yellow")!

        case .red:
            return UIImage(named: "pin_red")!
        }
    }
}

struct PlacemarkUserData {
    let name: String
    let type: PlacemarkType
}
