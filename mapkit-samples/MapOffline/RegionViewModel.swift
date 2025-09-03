//
//  SearchViewModel.swift
//  MapSearch
//

import Combine
import YandexMapsMobile

class RegionViewModel {
    // MARK: - Public properties

    @Published var region: RegionInfo?

    // MARK: - Public methods

    func setupSubscriptions() {
        setupRegionSubscription()
    }

    func setRegion(with regionId: Int) {
        self.regionId = regionId
    }

    func setRegionOpened(with regionId: Int) {
        self.regionIdOpened = regionId
    }

    deinit {
        bag.removeAll()
    }

    // MARK: - Private methods

    private func setupRegionSubscription() {
        $regionId
            .sink { [weak self] regionId in
                guard self?.regionIdOpened == regionId else { return }
                let cacheRegion = self?.offlineManager.regions().first { $0.id == regionId ?? .zero }
                self?.region = RegionInfo(
                    id: "\(cacheRegion?.id ?? .zero)",
                    name: cacheRegion?.name ?? "",
                    country: cacheRegion?.country ?? "",
                    center: "\(cacheRegion?.center.latitude ?? .zero) \(cacheRegion?.center.longitude ?? .zero)",
                    cities: self?.offlineManager
                        .getCitiesWithRegionId(UInt(regionId ?? .zero)).joined(separator: ", ") ?? "",
                    size: cacheRegion?.size.text ?? "",
                    downloadProgress: self?.offlineManager.getProgressWithRegionId(UInt(regionId ?? .zero)) ?? .zero,
                    parentId: "\(cacheRegion?.parentId ?? NSNumber())",
                    state: self?.getDownloadState(regionId: regionId ?? .zero) ?? "",
                    realeseTime: self?.convertTimeString(with: cacheRegion?.releaseTime ?? Date()) ?? "",
                    downloadedReleaseTime: self?.convertTimeString(
                        with: self?.offlineManager
                            .getDownloadedReleaseTime(withRegionId: (UInt(regionId ?? .zero))) ?? Date()
                    ) ?? ""
                )
            }
            .store(in: &bag)
    }

    private func getDownloadState(regionId: Int) -> String {
        switch self.offlineManager.getStateWithRegionId(UInt(regionId)) {
        case .available:
            return "AVAILABLE"
        case .downloading:
            return "DOWNLOADING"
        case .paused:
            return "PAUSED"
        case .completed:
            return "COMPLETED"
        case .outdated:
            return "OUTDATED"
        case .unsupported:
            return "UNSUPPORTED"
        case .needUpdate:
            return "NEED UPDATE"
        default:
            return ""
        }
    }

    private func convertTimeString(with date: Date) -> String? {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: date)
    }

    // MARK: - Private properties

    private lazy var offlineManager = YMKMapKit.sharedInstance().offlineCacheManager

    @Published private var regionId: Int?
    private var regionIdOpened: Int?

    private var bag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {

    }
}
