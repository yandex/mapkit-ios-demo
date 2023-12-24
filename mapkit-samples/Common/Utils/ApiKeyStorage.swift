//
//  ApiKeyStorage.swift
//  MapkitSamples
//

import Foundation
import YandexMapsMobile

enum ApiKeyStorage {
    static let mapkitApiKey = Bundle.main.object(forInfoDictionaryKey: "MAPKIT_API_KEY") as? String ?? ""
}
