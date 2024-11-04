//
//  MapCameraListener.swift
//  MapSearch
//

import YandexMapsMobile

class OfflineCacheRegionListener: NSObject, YMKOfflineCacheRegionListener {

    // MARK: - Constructor

    init(regionViewModel: RegionViewModel) {
        self.regionViewModel = regionViewModel
    }

    // MARK: - Public methods

    func onRegionStateChanged(withRegionId regionId: UInt) {
        regionViewModel.setRegion(with: Int(regionId))
    }

    func onRegionProgress(withRegionId regionId: UInt) {
        regionViewModel.setRegion(with: Int(regionId))
    }

    // MARK: - Private properties

    private let regionViewModel: RegionViewModel
}
