import UIKit
import Foundation
import YandexMapsMobile

/**
 * This example shows how to activate selection.
 */
class MapSelectionViewController: BaseMapViewController, YMKLayersGeoObjectTapListener, YMKMapInputListener {

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: Const.targetLocation, zoom: 17, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)

        mapView.mapWindow.map.addTapListener(with: self)
        mapView.mapWindow.map.addInputListener(with: self)
    }

    func onObjectTap(with: YMKGeoObjectTapEvent) -> Bool {
        let event = with
        let metadata = event.geoObject.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
        if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
            mapView.mapWindow.map.selectGeoObject(withSelectionMetaData:selectionMetadata)
            return true
        }
        return false
    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {
        mapView.mapWindow.map.deselectGeoObject()
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
    }
}
