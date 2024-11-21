//
//  SearchViewModel.swift
//  MapSearch
//

import Combine
import YandexMapsMobile

class OptionsViewModel {
    // MARK: - Public properties

    @Published var progress: Float?
    @Published var isSuccessMove: Bool?
    @Published var errorText: String?

    // MARK: - Private properties

    private var bag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {

    }
}
