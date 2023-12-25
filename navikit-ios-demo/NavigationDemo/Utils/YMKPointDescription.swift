//
//  YMKPointDescription.swift
//  NavigationDemo
//

import YandexMapsMobile

extension YMKPoint {
    var humanReadableDescription: String {
        "(\(latitude), \(longitude))"
    }
}
