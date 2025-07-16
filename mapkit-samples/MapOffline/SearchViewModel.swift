//
//  SearchViewModel.swift
//  MapSearch
//

import Combine
import YandexMapsMobile

class SearchViewModel {
    // MARK: - Public properties

    @Published var mapUIState: MapUIState!
    @Published var regionListState = RegionListState.idle

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
        query = String()
    }

    func stopSearch() {
        searchSession?.cancel()
        searchSession = nil
        searchState = .idle
    }

    func setupSubscriptions() {
        setupVisibleRegionSubscription()
        setupSearchSubscription()
        setupMapUIStateSubscription()
    }

    // MARK: - Private methods

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
                $regionListState
            )
            .map { query, searchState, regionListState in
                MapUIState(
                    query: query,
                    searchState: searchState,
                    regionListState: regionListState
                )
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

    private func onSearchError(error: Error) {
        searchState = .error
    }

    // MARK: - Private properties

    private lazy var searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?
    private var zoomToSearchResult = false

    @Published private var visibleRegion: YMKVisibleRegion?
    @Published private var debouncedVisibleRegion: YMKVisibleRegion?

    @Published private var query = String()
    @Published private var searchState = SearchState.idle

    private var bag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {
        static let searchOptions: YMKSearchOptions = {
            let options = YMKSearchOptions()
            options.resultPageSize = 32
            return options
        }()
    }
}
