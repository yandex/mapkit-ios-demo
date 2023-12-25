//
//  NavigationStyleManager.swift
//  NavigationDemo
//

import YandexMapsMobile

protocol NavigationStyleManager: YMKNavigationStyleProvider {
    // MARK: - Public properties

    var trafficLightsVisibility: Bool { get set }
    var roadEventsOnRouteVisibility: Bool { get set }
    var balloonsVisibility: Bool { get set }
    var predictedVisibility: Bool { get set }
    var currentJamsMode: JamsMode { get set }
}
