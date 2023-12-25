//
//  MapSizeChangedListener.swift
//  NavigationDemoApp
//

import YandexMapsMobile

final class MapSizeChangedListener: NSObject, YMKMapSizeChangedListener {
    // MARK: - Constructor

    init(mapWindow: YMKMapWindow, mapViewStateManager: MapViewStateManager) {
        self.mapWindow = mapWindow
        self.mapViewStateManager = mapViewStateManager
    }

    // MARK: - Public methods

    func onMapWindowSizeChanged(with mapWindow: YMKMapWindow, newWidth: Int, newHeight: Int) {
        updateFocusRect()
    }

    func updateFocusRect() {
        let scale = Float(UIScreen.main.scale)

        let rect = YMKScreenRect(
            topLeft: YMKScreenPoint(
                x: Float(Const.leadingPadding) * scale,
                y: Float(Const.topPadding) * scale
            ),
            bottomRight: YMKScreenPoint(
                x: Float(mapWindow.width()) - Const.trailingPadding * scale,
                y: Float(mapWindow.height()) - bottomPadding * scale
            )
        )

        mapWindow.focusRect = rect

        if mapViewStateManager.viewState.value == .guidance {
            let width = mapWindow.focusRect!.bottomRight.x - mapWindow.focusRect!.topLeft.x

            mapWindow.focusPoint = YMKScreenPoint(
                x: mapWindow.focusRect!.topLeft.x + width / 2,
                y: Float(mapWindow.height()) - (bottomPadding + Const.placemarkPadding) * scale
            )
        }
    }

    // MARK: - Private properties

    private var bottomPadding: Float {
        switch mapViewStateManager.viewState.value {
        case .map:
            return 20.0

        case .routeVariants:
            return 150.0 + 20.0

        case .guidance:
            return 180.0 + 20.0
        }
    }

    private let mapWindow: YMKMapWindow
    private let mapViewStateManager: MapViewStateManager

    // MARK: - Private nesting

    private enum Const {
        static let topPadding: CGFloat = 50.0
        static let leadingPadding: CGFloat = 10.0
        static let trailingPadding: Float = 80.0
        static let placemarkPadding: Float = 30.0
    }
}
