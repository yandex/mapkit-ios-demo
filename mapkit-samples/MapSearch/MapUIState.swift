//
//  MapUIState.swift
//  MapSearch
//

import YandexMapsMobile

struct MapUIState {
    let query: String
    let searchState: SearchState
    let suggestState: SuggestState

    init(query: String = String(), searchState: SearchState, suggestState: SuggestState) {
        self.query = query
        self.searchState = searchState
        self.suggestState = suggestState
    }
}

struct SearchResponseItem {
    let point: YMKPoint
    let geoObject: YMKGeoObject?
}

enum SearchState {
    case idle
    case loading
    case error
    case success(items: [SearchResponseItem], zoomToItems: Bool, itemsBoundingBox: YMKBoundingBox)
}

enum SuggestState {
    case idle
    case loading
    case error
    case success(items: [SuggestItem])
}
