//
//  SpeakerImpl.swift
//  NavigationDemo
//

import AVFoundation
import Combine
import YandexMapsMobile

class SpeakerImpl: NSObject, Speaker {
    // MARK: - Public properties

    var phrases = CurrentValueSubject<String, Never>(String())

    // MARK: - Public methods

    func reset() {
        textToSpeech.stopSpeaking(at: .word)
    }

    func say(with phrase: YMKLocalizedPhrase) {
        if voice != nil {
            let utterance = AVSpeechUtterance(string: phrase.text)
            utterance.voice = voice
            textToSpeech.speak(utterance)
        }
        phrases.send(phrase.text)
    }

    func duration(with phrase: YMKLocalizedPhrase) -> Double {
        Double(phrase.text.count) * 0.061 + 0.65
    }

    func setLanguage(with language: YMKAnnotationLanguage) {
        voice = AVSpeechSynthesisVoice(language: languageCode(of: language))
    }

    // MARK: - Private methods

    func languageCode(of language: YMKAnnotationLanguage) -> String {
        switch language {
        case .english:
            return "en-US"
        case .russian:
            return "ru-RU"
        case .french:
            return "fr-FR"
        case .ukrainian:
            return "uk-UA"
        case .italian:
            return "it-IT"
        case .turkish:
            return "tr-TR"
        case .hebrew:
            return "he-IL"
        case .serbian:
            return "sr-Latn-RS"
        case .latvian:
            return "lv-LV"
        case .finnish:
            return "fi-FI"
        case .romanian:
            return "ro-RO"
        case .kyrgyz:
            return "ky-KG"
        case .kazakh:
            return "kk-KZ"
        case .lithuanian:
            return "lt-LT"
        case .estonian:
            return "et-EE"
        case .georgian:
            return "ka-GE"
        case .uzbek:
            return "uz-UZ"
        case .armenian:
            return "hy-AM"
        case .azerbaijani:
            return "az-AZ"
        case .tatar:
            return "tt-TT"
        case .arabic:
            return "ar-AR"
        case .portuguese:
            return "pt-PT"
        case .latinAmericanSpanish:
            return "es-419"
        @unknown default:
            print("Unknown language - \(language)")
            return String()
        }
    }

    // MARK: - Private properties

    private let textToSpeech = AVSpeechSynthesizer()
    var voice: AVSpeechSynthesisVoice?
}
