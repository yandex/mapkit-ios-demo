//
//  MapViewController.swift
//  MapSearch
//

import Combine
import UIKit
import YandexMapsMobile

class MapViewController: UIViewController {
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)

        map = mapView.mapWindow.map

        map.addCameraListener(with: mapCameraListener)
        offlineManager.addRegionListUpdatesListener(with: regionListUpdatesListener)

        searchViewModel.setupSubscriptions()

        setupSearchController()

        setupSubviews()

        moveToStartPoint()
    }

    // MARK: - Private methods

    private func moveToStartPoint() {
        map.move(with: Const.startPosition, animation: YMKAnimation(type: .smooth, duration: 0.5))
        searchViewModel.setVisibleRegion(with: map.visibleRegion)
    }

    private func setupSearchController() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.searchBarController.searchBar.placeholder = "Search places"

        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.showsBookmarkButton = false

        searchBarController.view.backgroundColor = .white
        resultsTableController.view.backgroundColor = .white
        searchBarController.searchResultsController?.view.isHidden = false

        resultsTableController.tableView.contentInset = .init(top: 50, left: .zero, bottom: .zero, right: .zero)
        resultsTableController.edgesForExtendedLayout = .bottom
        resultsTableController.tableView.delegate = self

        setupStateUpdates()
    }

    private func setupSubviews() {
        view.addSubview(menuView)
        menuView.axis = .horizontal
        menuView.alignment = .fill
        menuView.distribution = .equalSpacing
        menuView.spacing = 15
        menuView.translatesAutoresizingMaskIntoConstraints = false

        [
            menuView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        .forEach { $0.isActive = true }

        [regionListButton, optionsButton]
            .forEach {
                menuView.addArrangedSubview($0)

                $0.translatesAutoresizingMaskIntoConstraints = false
                [
                    $0.heightAnchor.constraint(equalToConstant: 36)
                ]
                .forEach { $0.isActive = true }

                $0.layer.cornerRadius = 4
                $0.setTitleColor(.black, for: .normal)
                $0.contentMode = .scaleAspectFill
                $0.backgroundColor = Palette.background
            }

        regionListButton.addTarget(
            self,
            action: #selector(regionListButtonTapHandler),
            for: .touchUpInside
        )
        regionListButton.setTitle("REGION LIST", for: .normal)

        optionsButton.addTarget(
            self,
            action: #selector(optionsButtonTapHandler),
            for: .touchUpInside
        )
        optionsButton.setTitle("OPTIONS", for: .normal)
    }

    @objc
    private func regionListButtonTapHandler() {
        present(searchBarController, animated: true)
        searchViewModel.setQueryText(with: "")
    }

    @objc
    private func optionsButtonTapHandler() {
        present(optionsViewController, animated: true)
    }

    private func focusCamera(points: [YMKPoint], boundingBox: YMKBoundingBox) {
        if points.isEmpty {
            return
        }

        let position = map.cameraPosition(with: YMKGeometry(boundingBox: boundingBox))

        map.move(with: position, animation: YMKAnimation(type: .smooth, duration: 0.5))
    }

    private func displaySearchResults(
        items: [SearchResponseItem],
        zoomToItems: Bool,
        itemsBoundingBox: YMKBoundingBox
    ) {
        map.mapObjects.clear()

        items.forEach { item in
            let image = UIImage(systemName: "circle.circle.fill")!
                .withTintColor(view.tintColor)

            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = item.point
            placemark.setViewWithView(YRTViewProvider(uiView: UIImageView(image: image)))

            placemark.userData = item.geoObject
        }
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private lazy var map: YMKMap = mapView.mapWindow.map
    private lazy var mapCameraListener = MapCameraListener(searchViewModel: searchViewModel)

    private let menuView = UIStackView()
    private let regionListButton = UIButton()
    private let optionsButton = UIButton()

    private lazy var regionListUpdatesListener = OfflineMapRegionListUpdatesListener(searchViewModel: searchViewModel)
    private lazy var offlineManager = YMKMapKit.sharedInstance().offlineCacheManager
    private lazy var resultsTableController = ResultsTableController()
    private lazy var searchBarController = UISearchController(searchResultsController: resultsTableController)
    private lazy var regionViewController = RegionViewController()
    private lazy var optionsViewController = OptionsViewController()
    private let searchViewModel = SearchViewModel()
    private var bag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {
        static let startPoint = YMKPoint(latitude: 55.753284, longitude: 37.622034)
        static let startPosition = YMKCameraPosition(target: startPoint, zoom: 13.0, azimuth: .zero, tilt: .zero)
    }

    // MARK: - Layout

    private enum Layout {
        static let buttonSize: CGFloat = 50.0
    }
}

extension MapViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.reset()
        searchViewModel.setQueryText(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.startSearch()
        searchBarController.searchBar.text = searchViewModel.mapUIState.query
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if case .idle = searchViewModel.mapUIState.searchState {
            updatePlaceholder()
        }
    }

    func setupStateUpdates() {
        searchViewModel.$mapUIState.sink { [weak self] state in
            let query = state?.query ?? String()
            self?.searchBarController.searchBar.text = query
            self?.updatePlaceholder(with: query)

            if case let .success(items, zoomToItems, itemsBoundingBox) = state?.searchState {
                if zoomToItems {
                    self?.focusCamera(points: items.map { $0.point }, boundingBox: itemsBoundingBox)
                }
            }
            if let regionState = state?.regionListState,
               case .success = state?.regionListState {
                self?.updateRegions(with: regionState, query: query)
            }
        }
        .store(in: &bag)
    }

    private func showRegionInfo(regionId: Int) {
        regionViewController.setRegion(with: regionId)
        present(regionViewController, animated: true)
    }

    private func updateRegions(with regionListState: RegionListState, query: String) {
        switch regionListState {
        case .success:
            resultsTableController.items = offlineManager.regions()
                .map { region in
                    RegionItem(model: region) {
                        self.searchViewModel.startSearch(with: region.name)
                        self.showRegionInfo(regionId: Int(region.id))
                    }
                }
                .filter { $0.model.name.contains(query) }
            resultsTableController.tableView.reloadData()
        default:
            return
        }
    }

    private func updatePlaceholder(with text: String = String()) {
        searchBarController.searchBar.placeholder = text.isEmpty ? "Search places" : text
    }
}

extension MapViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < resultsTableController.items.count else { return }

        searchBarController.isActive = false

        let item = resultsTableController.items[indexPath.row]
        item.onClick()
    }
}

private class ResultsTableController: UITableViewController {

    private let cellIdentifier = "cellIdentifier"

    var items = [RegionItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0

        let item = items[indexPath.row]

        cell.textLabel?.attributedText = item.cellText

        return cell
    }
}

fileprivate extension RegionItem {

    var cellText: NSAttributedString {
        let result = NSMutableAttributedString(string: model.name)
        result.append(NSAttributedString(string: " "))

        let subtitle = NSMutableAttributedString(string: "")
        subtitle.setAttributes(
            [.foregroundColor: UIColor.secondaryLabel],
            range: NSRange(location: 0, length: subtitle.string.count)
        )
        result.append(subtitle)

        return result
    }
}
