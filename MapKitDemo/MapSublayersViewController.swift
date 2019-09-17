import UIKit
import YandexMapKit

/**
 * This example shows how to reorder sublayers and use conflict resolving.
 */
class MapSublayersViewController: UIViewController {
    @IBOutlet var mapView: YMKMapView!

    let CAMERA_TARGET = YMKPoint(latitude: 59.951029, longitude: 30.317181)

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 16, azimuth: 0, tilt: 45))
    }
}
