import UIKit
import Foundation
import YandexMapsMobile

/**
 * This example shows how to add layer with simple objects such as points, polylines, polygons
 * to the map using GeoJSON format.
 */
class GeoJsonViewController: BaseMapViewController {

    let CAMERA_TARGET = YMKPoint(latitude: 59.952, longitude: 30.318)

    internal class CustomImagesUrlProvider: NSObject, YMKImagesImageUrlProvider {
        func formatUrl(with descriptor: YMKImagesImageDataDescriptor) -> String {
            return "https://raw.githubusercontent.com/yandex/mapkit-ios-demo/master/MapKitDemo/\(descriptor.imageId)"
        }
    }

    private static func readRawJson(resourceName: String) -> String? {
        if let filepath: String = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                NSLog("JsonError: Contents could not be loaded from json file: " + resourceName)
                return nil
            }
        } else {
            NSLog("JsonError: json file not found: " + resourceName)
            return nil
        }
    }

    internal class CustomTileProvider: NSObject, YMKTileProvider {

        private let geoJsonTemplate: String
        
        private static let MAX_ZOOM: Int = 30
        
        let projection: YMKProjection = YMKProjections.wgs84Mercator()

        override init() {
            self.geoJsonTemplate = GeoJsonViewController.readRawJson(resourceName: "geo_json_example_template")!
        }

        func load(with tileId: YMKTileId, version: YMKVersion, etag: String) -> YMKRawTile {
            let tileSize: Int = 1 << (CustomTileProvider.MAX_ZOOM - Int(tileId.z))

            let left: Int = Int(tileId.x) * tileSize
            let right: Int = left + tileSize
            let bottom: Int = Int(tileId.y) * tileSize
            let top: Int = bottom + tileSize
            
            let leftBottom: YMKPoint = self.projection.xyToWorld(
                with: YMKXYPoint.xYPointWith(x: Double(left), y: Double(bottom)),
                zoom: CustomTileProvider.MAX_ZOOM)
            let rightTop: YMKPoint = self.projection.xyToWorld(
                with: YMKXYPoint.xYPointWith(x: Double(right), y: Double(top)),
                zoom: CustomTileProvider.MAX_ZOOM)

            let tileLeft: Double = leftBottom.longitude
            let tileRight: Double = rightTop.longitude
            let tileBottom: Double = leftBottom.latitude
            let tileTop: Double = rightTop.latitude
            
            var map: [String: Double] = [:]

            map["@POINT_X@"] = 0.7 * tileLeft   + 0.3 * tileRight
            map["@POINT_Y@"] = 0.7 * tileBottom + 0.3 * tileTop

            map["@LINE_X0@"] = 0.9 * tileLeft   + 0.1 * tileRight
            map["@LINE_Y0@"] = 0.9 * tileBottom + 0.1 * tileTop
            map["@LINE_X1@"] = 0.9 * tileLeft   + 0.1 * tileRight
            map["@LINE_Y1@"] = 0.1 * tileBottom + 0.9 * tileTop
            map["@LINE_X2@"] = 0.1 * tileLeft   + 0.9 * tileRight
            map["@LINE_Y2@"] = 0.1 * tileBottom + 0.9 * tileTop
            map["@LINE_X3@"] = 0.1 * tileLeft   + 0.9 * tileRight
            map["@LINE_Y3@"] = 0.9 * tileBottom + 0.1 * tileTop

            map["@POLYGON_X0@"] = 0.2 * tileLeft   + 0.8 * tileRight
            map["@POLYGON_Y0@"] = 0.8 * tileBottom + 0.2 * tileTop
            map["@POLYGON_X1@"] = 0.5 * tileLeft   + 0.5 * tileRight
            map["@POLYGON_Y1@"] = 0.5 * tileBottom + 0.5 * tileTop
            map["@POLYGON_X2@"] = 0.2 * tileLeft   + 0.8 * tileRight
            map["@POLYGON_Y2@"] = 0.2 * tileBottom + 0.8 * tileTop

            map["@TEXTURED_POLYGON_X0@"] = 0.8 * tileLeft   + 0.2 * tileRight
            map["@TEXTURED_POLYGON_Y0@"] = 0.2 * tileBottom + 0.8 * tileTop
            map["@TEXTURED_POLYGON_X1@"] = 0.2 * tileLeft   + 0.8 * tileRight
            map["@TEXTURED_POLYGON_Y1@"] = 0.2 * tileBottom + 0.8 * tileTop
            map["@TEXTURED_POLYGON_X2@"] = 0.5 * tileLeft   + 0.5 * tileRight
            map["@TEXTURED_POLYGON_Y2@"] = 0.5 * tileBottom + 0.5 * tileTop
            
            var geoJson: String = geoJsonTemplate
            for (key, value) in map {
                geoJson = geoJson.replacingOccurrences(of: key, with: String(value))
            }
            
            return YMKRawTile(version: version, etag: etag, state: YMKRawTileState.ok, rawData: geoJson.data(using: .utf8)!)
        }
    }

    // Client code must retain strong references to providers and projection
    let urlProvider: YMKImagesImageUrlProvider = CustomImagesUrlProvider()
    let tileProvider: CustomTileProvider = CustomTileProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 15, azimuth: 0, tilt: 0))
        mapView.mapWindow.map.mapType = YMKMapType.vectorMap

        createGeoJsonLayer()
    }

    private func createGeoJsonLayer() {
        let style: String! = GeoJsonViewController.readRawJson(resourceName: "geo_json_style_example")
        
        let layerOptions = YMKLayerOptions()
        layerOptions.nightModeAvailable = true

        let layer: YMKLayer? = mapView.mapWindow.map.addGeoJSONLayer(
            withLayerId: "geo_json_layer",
            style: style,
            layerOptions: layerOptions,
            tileProvider: tileProvider,
            imageUrlProvider: urlProvider,
            projection: tileProvider.projection,
            zoomRanges: [])

        layer!.invalidate(withVersion: "0.0.0")
        layer!.activateWith(on: true)
    }
}
