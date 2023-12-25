//
//  Speaker.swift
//  NavigationDemo
//

import Combine
import YandexMapsMobile

protocol Speaker: YMKSpeaker {
    // MARK: - Public properties

    var phrases: CurrentValueSubject<String, Never> { get }

    // MARK: - Public methods

    func setLanguage(with language: YMKAnnotationLanguage)
}
