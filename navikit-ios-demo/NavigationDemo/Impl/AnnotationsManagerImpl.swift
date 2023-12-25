//
//  AnnotationsManagerImpl.swift
//  NavigationDemo
//

import Combine
import YandexMapsMobile

final class AnnotationsManagerImpl: NSObject, AnnotationsManager {
    // MARK: - Constructor

    init(
        speaker: Speaker,
        annotator: YMKAnnotator,
        settingsRepository: SettingsRepository,
        alertPresenter: AlertPresenter
    ) {
        self.speaker = speaker
        self.annotator = annotator
        self.settingsRepository = settingsRepository
        self.alertPresenter = alertPresenter

        annotatorListener = AnnotatorListener(alertPresenter: alertPresenter)

        super.init()
    }

    // MARK: - Public properties

    func start() {
        annotator.setSpeakerWith(speaker)
        annotator.addListener(with: annotatorListener)

        speaker.phrases
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                let toast = AlertFactory.make(with: text)
                self?.alertPresenter.present(alert: toast, selfDismissing: true)
            }
            .store(in: &cancellablesBag)
    }

    func setAnnotationsEnabled(isEnabled: Bool) {
        if isEnabled {
            annotator.unmute()
        } else {
            annotator.mute()
        }
    }

    func setAnnotatedEventEnabled(event: AnnotatedEventsType, isEnabled: Bool) {
        if isEnabled {
            annotator.annotatedEvents.insert(event.annotatedEvent)
        } else {
            annotator.annotatedEvents.remove(event.annotatedEvent)
        }
    }

    func setAnnotatedRoadEventEnabled(event: AnnotatedRoadEventsType, isEnabled: Bool) {
        if isEnabled {
            annotator.annotatedRoadEvents.insert(event.annotatedEvent)
        } else {
            annotator.annotatedRoadEvents.remove(event.annotatedEvent)
        }
    }

    // MARK: - Private properties

    private let speaker: Speaker
    private let annotator: YMKAnnotator
    private let settingsRepository: SettingsRepository
    private let alertPresenter: AlertPresenter

    private let annotatorListener: AnnotatorListener
    private var cancellablesBag = Set<AnyCancellable>()
}

final class AnnotatorListener: NSObject, YMKAnnotatorListener {
    // MARK: - Constructor

    init(alertPresenter: AlertPresenter) {
        self.alertPresenter = alertPresenter
    }

    // MARK: - Public properties

    func manoeuvreAnnotated() {
        let toast = AlertFactory.make(with: "Manoeuvre annotated")
        alertPresenter.present(alert: toast, selfDismissing: true)
    }

    func roadEventAnnotated() {
        let toast = AlertFactory.make(with: "Road event annotated")
        alertPresenter.present(alert: toast, selfDismissing: true)
    }

    func speedingAnnotated() {
        let toast = AlertFactory.make(with: "Speeding annotated")
        alertPresenter.present(alert: toast, selfDismissing: true)
    }

    func fasterAlternativeAnnotated() {
        let toast = AlertFactory.make(with: "Faster alternative annotated")
        alertPresenter.present(alert: toast, selfDismissing: true)
    }

    // MARK: - Private properties

    private let alertPresenter: AlertPresenter
}
