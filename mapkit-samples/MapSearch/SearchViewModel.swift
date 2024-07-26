//
//  SearchViewModel.swift
//  MapSearch
//

import Combine
import YandexMapsMobile

class SearchViewModel {
    // MARK: - Public properties

    @Published var mapUIState: MapUIState!

    // MARK: - Public methods

    func setQueryText(with text: String?) {
        query = text ?? String()
    }

    func setVisibleRegion(with region: YMKVisibleRegion) {
        visibleRegion = region
    }

    func startSearch(with searchText: String? = nil) {
        let text = searchText ?? query

        guard !text.isEmpty,
              let visibleRegion else {
            return
        }

        submitSearch(with: text, geometry: YMKVisibleRegionUtils.toPolygon(with: visibleRegion))
    }

    func reset() {
        stopSearch()
        resetSuggest()
        query = String()
    }

    func stopSearch() {
        searchSession?.cancel()
        searchSession = nil
        searchState = .idle
    }

    func setupSubscriptions() {
        setupVisibleRegionSubscription()
        setupSuggestSubscription()
        setupSearchSubscription()
        setupMapUIStateSubscription()
    }

    // MARK: - Private methods

    private func setupSuggestSubscription() {
        Publishers
            .CombineLatest3(
                $query,
                $debouncedVisibleRegion,
                $searchState
            )
            .sink { [weak self] query, visibleRegion, searchState in
                if let visibleRegion = visibleRegion,
                   !query.isEmpty,
                   case .idle = searchState {
                    self?.submitSuggest(
                        with: query,
                        boundingBox: YMKBoundingBox(
                            southWest: visibleRegion.bottomLeft,
                            northEast: visibleRegion.topRight
                        ),
                        options: Const.suggestOptions
                    )
                } else {
                    self?.resetSuggest()
                }
            }
            .store(in: &bag)
    }

    private func setupSearchSubscription() {
        $debouncedVisibleRegion
            .filter { [weak self] _ in
                if case .success = self?.searchState {
                    return true
                } else {
                    return false
                }
            }
            .compactMap { $0 }
            .sink { [weak self] visibleRegion in
                guard let self = self else {
                    return
                }
                self.searchSession?.setSearchAreaWithArea(YMKVisibleRegionUtils.toPolygon(with: visibleRegion))
                self.searchSession?.resubmit(responseHandler: self.handleSearchSessionResponse)
                self.searchState = .loading
                self.zoomToSearchResult = false
            }
            .store(in: &bag)
    }

    private func submitSearch(with query: String, geometry: YMKGeometry) {
        searchSession?.cancel()
        searchSession = searchManager.submit(
            withText: query,
            geometry: geometry,
            searchOptions: Const.searchOptions,
            responseHandler: handleSearchSessionResponse
        )
        searchState = .loading
        zoomToSearchResult = true
    }

    private func submitUriSearch(uri: String) {
        searchSession?.cancel()
        searchSession = searchManager.searchByURI(
            withUri: uri,
            searchOptions: YMKSearchOptions(),
            responseHandler: handleSearchSessionResponse
        )
        searchState = .loading
        zoomToSearchResult = true
    }

    private func submitSuggest(with query: String, boundingBox: YMKBoundingBox, options: YMKSuggestOptions) {
        suggestSession.suggest(
            withText: query,
            window: boundingBox,
            suggestOptions: options,
            responseHandler: handleSuggestSessionResponse
        )
        suggestState = .loading
    }

    private func resetSuggest() {
        suggestSession.reset()
        suggestState = .idle
    }

    private func setupVisibleRegionSubscription() {
        $visibleRegion
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .assign(to: \.debouncedVisibleRegion, on: self)
            .store(in: &bag)
    }

    private func setupMapUIStateSubscription() {
        Publishers
            .CombineLatest3(
                $query,
                $searchState,
                $suggestState
            )
            .map { query, searchState, suggestState in
                MapUIState(query: query, searchState: searchState, suggestState: suggestState)
            }
            .assign(to: \.mapUIState, on: self)
            .store(in: &bag)
    }

    private func handleSearchSessionResponse(response: YMKSearchResponse?, error: Error?) {
        if let error = error {
            onSearchError(error: error)
            return
        }

        guard let response = response,
              let boundingBox = response.metadata.boundingBox else {
            return
        }

        let items = response.collection.children.compactMap {
            if let point = $0.obj?.geometry.first?.point {
                return SearchResponseItem(point: point, geoObject: $0.obj)
            } else {
                return nil
            }
        }

        searchState = SearchState.success(
            items: items,
            zoomToItems: zoomToSearchResult,
            itemsBoundingBox: boundingBox
        )
    }

    private func handleSuggestSessionResponse(response: YMKSuggestResponse?, error: Error?) {
        if let error = error {
            onSuggestError(error: error)
            return
        }

        guard let items = response?.items else {
            return
        }
        let suggestItems = items
            .map { [weak self] item in
                SuggestItem(title: item.title, subtitle: item.subtitle) {
                    self?.setQueryText(with: item.displayText)
                    if item.action == .search {
                        if let uri = item.uri {
                            self?.submitUriSearch(uri: uri)
                        } else {
                            self?.startSearch(with: item.searchText)
                        }
                    }
                }
            }

        suggestState = .success(items: suggestItems)
    }

    private func onSearchError(error: Error) {
        searchState = .error
    }

    private func onSuggestError(error: Error) {
        suggestState = .error
    }

    // MARK: - Private properties

    private lazy var searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?
    private lazy var suggestSession: YMKSearchSuggestSession = searchManager.createSuggestSession()
    private var zoomToSearchResult = false

    @Published private var visibleRegion: YMKVisibleRegion?
    @Published private var debouncedVisibleRegion: YMKVisibleRegion?

    @Published private var query = String()
    @Published private var searchState = SearchState.idle
    @Published private var suggestState = SuggestState.idle

    private var bag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {
        static let suggestOptions = YMKSuggestOptions(
            suggestTypes: [.biz, .geo, .transit],
            userPosition: nil,
            suggestWords: true,
            strictBounds: false
        )
        static let searchOptions: YMKSearchOptions = {
            let options = YMKSearchOptions()
            options.resultPageSize = 32
            return options
        }()
    }
}
