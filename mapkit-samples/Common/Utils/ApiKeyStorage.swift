//
//  ApiKeyStorage.swift
//  MapkitSamples
//
//  Created by Daniil Pustotin on 06.07.2023.
//

import Foundation
import YandexMapsMobile

enum ApiKeyStorage {
    static let mapkitApiKey = Bundle.main.object(forInfoDictionaryKey: "MAPKIT_API_KEY") as? String ?? ""
}
