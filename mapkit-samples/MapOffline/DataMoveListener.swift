//
//  MapCameraListener.swift
//  MapSearch
//

import YandexMapsMobile

class DataMoveListener: NSObject, YMKOfflineCacheDataMoveListener {

    // MARK: - Constructor

    init(optionViewModel: OptionsViewModel) {
        self.optionViewModel = optionViewModel
    }

    // MARK: - Public methods

    func onDataMoveProgress(withPercent percent: Int) {
        optionViewModel.progress = Float(percent)
    }

    func onDataMoveCompleted() {
        optionViewModel.isSuccessMove = true
    }

    func onDataMoveErrorWithError(_ error: any Error) {
        optionViewModel.errorText = error.localizedDescription
    }

    // MARK: - Private properties

    private let optionViewModel: OptionsViewModel
}
