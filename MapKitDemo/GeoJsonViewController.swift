import UIKit
import Foundation
import YandexMapKit

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

    internal class CustomTileProvider: NSObject, YMKTileProvider {

        private let rawJson: String

        override init() {
            self.rawJson = CustomTileProvider.readRawJson()!
        }

        private static func readRawJson() -> String? {
            if let filepath: String = Bundle.main.path(forResource: "geo_json_example", ofType: "geojson") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    return contents
                } catch {
                    NSLog("GeoJsonError: Contents could not be loaded from geojson file")
                    return nil
                }
            } else {
                NSLog("GeoJsonError: geojson file not found")
                return nil
            }
        }

        func load(with tileId: YMKTileId, version: YMKVersion, etag: String) -> YMKRawTile {
            return YMKRawTile(version: version, etag: etag, state: YMKRawTileState.ok, rawData: rawJson.data(using: .utf8)!)
        }
    }

    // Client code must retain strong references to providers and projection
    let projection: YMKProjection = YMKCreateWgs84Mercator()
    let urlProvider: YMKResourceUrlProvider = CustomResourceUrlProvider()
    let tileProvider: YMKTileProvider = CustomTileProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 15, azimuth: 0, tilt: 0))
        mapView.mapWindow.map.mapType = YMKMapType.vectorMap

        createGeoJsonLayer()
    }

    private func createGeoJsonLayer() {
        let layer: YMKLayer? = mapView.mapWindow.map.addLayer(
            withLayerId: "geo_json_layer",
            contentType: "application/geo-json",
            layerOptions: YMKLayerOptions(),
            tileProvider: tileProvider,
            imageUrlProvider: urlProvider,
            projection: projection)

        layer!.invalidate(withVersion: "0.0.0")
        layer!.activateWith(on: true)
    }
}
