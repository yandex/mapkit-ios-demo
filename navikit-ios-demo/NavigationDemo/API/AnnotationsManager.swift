//
//  AnnotationsManager.swift
//  NavigationDemo
//

import YandexMapsMobile

protocol AnnotationsManager {
    // MARK: - Public methods

    func start()
    func setAnnotationsEnabled(isEnabled: Bool)
    func setAnnotatedEventEnabled(event: AnnotatedEventsType, isEnabled: Bool)
    func setAnnotatedRoadEventEnabled(event: AnnotatedRoadEventsType, isEnabled: Bool)
}
