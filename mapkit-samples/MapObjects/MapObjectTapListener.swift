//
//  MapObjectTapListener.swift
//  MapObjects
//

import YandexMapsMobile

final class MapObjectTapListener: NSObject, YMKMapObjectTapListener {
    // MARK: - Constructor

    init(controller: UIViewController) {
        self.controller = controller
    }

    // MARK: - Public methods

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        let alertTitle: String
        let alertMessage: String

        switch mapObject {
        case let polylineObject as YMKPolylineMapObject:
            polylineObject.setStrokeColorWith(PolylineColorPalette.color)
            alertTitle = "Tapped the polyline"
            alertMessage = "Changed color"
        case let circleObject as YMKCircleMapObject:
            let circleGeometry = GeometryProvider.circleWithRandomRadius
            circleObject.geometry = circleGeometry
            alertTitle = "Tapped the circle"
            alertMessage = "Changed radius to \(circleGeometry.radius)"
        default:
            alertTitle = "Tapped the placemark"
            alertMessage = String(describing: mapObject.userData)
        }

        AlertPresenter.present(
            from: controller,
            with: alertTitle,
            message: alertMessage
        )
        return true
    }

    // MARK: - Private properties

    private weak var controller: UIViewController?
}
