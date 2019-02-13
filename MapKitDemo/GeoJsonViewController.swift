import UIKit
import Foundation
import YandexMapKit
import os.log

/**
 * This example shows how to add layer with simple objects such as points, polylines, polygons
 * to the map using GeoJSON format.
 */
class GeoJsonViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!

    let CAMERA_TARGET = YMKPoint(latitude: 59.952, longitude: 30.318)

    internal class CustomResourceUrlProvider: NSObject, YMKResourceUrlProvider {
        public func formatUrl(withResourceId resourceId: String) -> String {
            return "https://raw.githubusercontent.com/yandex/mapkit-android-demo/master/src/main/\(resourceId)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 15, azimuth: 0, tilt: 0))
        mapView.mapWindow.map.mapType = YMKMapType.vectorMap

        createGeoJsonLayer()
    }

    private func createGeoJsonLayer() {
        let tileProvider: YMKTileProvider? = createTileProvider()
        if (tileProvider == nil) {
            os_log("TileProvider could not be created", log: OSLog.default, type: OSLogType.error)
            return
        }
        let urlProvider: YMKResourceUrlProvider = CustomResourceUrlProvider()
        let projection: YMKProjection = YMKCreateWgs84Mercator()

        let layer: YMKLayer? = mapView.mapWindow.map.addLayer(
            withLayerId: "geo_json_layer",
            contentType: "application/geo-json",
            layerOptions: YMKLayerOptions(),
            tileProvider: tileProvider!,
            imageUrlProvider: urlProvider,
            projection: projection)

        layer!.invalidate(withVersion: "0.0.0")
    }

    private func createTileProvider() -> YMKTileProvider? {
        if let filepath: String = Bundle.main.path(forResource: "geo_json_example", ofType: "geojson") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return CustomTileProvider(rawJson: contents)
            } catch {
                os_log("Contents could not be loaded from geojson file", log: OSLog.default, type: OSLogType.error)
                return nil
            }
        } else {
            os_log("geojson file not found", log: OSLog.default, type: OSLogType.error)
            return nil
        }
    }

    internal class CustomTileProvider: NSObject, YMKTileProvider {

        private let rawJson: String

        init(rawJson: String) {
            self.rawJson = rawJson
        }

        func load(with tileId: YMKTileId, version: YMKVersion, etag: String) -> YMKRawTile {
            return YMKRawTile(version: version, etag: etag, state: YMKRawTileState.ok, rawData: rawJson.data(using: .utf8)!)
        }
    }
}
