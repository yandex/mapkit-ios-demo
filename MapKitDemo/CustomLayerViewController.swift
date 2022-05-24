import UIKit
import YandexMapsMobile

/**
 * This example shows how to add a user-defined layer to the map.
 * We use the UrlProvider class to format requests to a remote server that renders
 * tiles. For simplicity, we ignore map coordinates and zoom here, and
 * just provide a URL for the static image.
 */
class CustomLayerViewController: BaseMapViewController {
    
    var layer: YMKLayer?

    internal class CustomTilesUrlProvider: NSObject, YMKTilesUrlProvider {
        func formatUrl(with tileId: YMKTileId, version: YMKVersion) -> String {
            return "https://maps-ios-pods-public.s3.yandex.net/mapkit_logo.png"
        }
    }

    // MapKit  doesn't need Url provider for raster maps.
    internal class DummyUrlProvider : NSObject, YMKResourceUrlProvider {
        override init() {}

        func formatUrl(withResourceId resourceId: String) -> String {
            return "";
        }

        override func isEqual(_ object: Any?) -> Bool {
            return true;
        }
    }

    // Client code must retain strong references to providers and projection
    let tilesUrlProvider = CustomTilesUrlProvider()
    let projection = YMKProjections.wgs84Mercator()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.mapType = .none

        let layerOptions = YMKLayerOptions(
            active: true,
            nightModeAvailable: true,
            cacheable: true,
            animateOnActivation: true,
            tileAppearingAnimationDuration: 0,
            overzoomMode: .enabled,
            transparent: false
        )

        layer = mapView.mapWindow.map.addLayer(
            withLayerId: "mapkit_logo",
            contentType: "image/png",
            layerOptions: layerOptions,
            tileUrlProvider: tilesUrlProvider,
            imageUrlProvider: YMKImagesDefaultUrlProvider(),
            projection: projection)

        layer!.invalidate(withVersion: "0.0.0")
    }
}
