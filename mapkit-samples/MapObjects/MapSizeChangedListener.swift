//
//  MapSizeChangedListener.swift
//  MapObjects
//
//  Created by Daniil Pustotin on 03.08.2023.
//

import YandexMapsMobile

final class MapSizeChangedListener: NSObject, YMKMapSizeChangedListener {
    // MARK: - Constructor

    init(onSizeChanged sizeChangedHandler: @escaping () -> Void) {
        self.sizeChangedHandler = sizeChangedHandler
    }

    // MARK: - Public methods

    func onMapWindowSizeChanged(with mapWindow: YMKMapWindow, newWidth: Int, newHeight: Int) {
        sizeChangedHandler()
    }

    // MARK: - Private properties

    private let sizeChangedHandler: () -> Void
}
