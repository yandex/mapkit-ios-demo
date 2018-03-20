import UIKit
import YandexMapKit

/**
 * This example shows how to add a user-defined layer to the map.
 * We use the UrlProvider class to format requests to a remote server that renders
 * tiles. For simplicity, we ignore map coordinates and zoom here, and
 * just provide a URL for the static image.
 */
class CustomLayerViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    
    var layer: YMKLayer?

    internal class CustomTilesUrlProvider: NSObject, YMKTilesUrlProvider {
        func formatUrl(with tileId: YMKTileId, version: YMKVersion) -> String {
            return "https://maps-ios-pods-public.s3.yandex.net/mapkit_logo.png"
        }
    }
    
    // Client code must retain strong references to providers and projection
    let tilesUrlProvider = CustomTilesUrlProvider()
    let projection = YMKCreateWgs84Mercator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapWindow.map!.mapType = .none
        
        let layerOptions = YMKLayerOptions(
            active: true,
            nightModeAvailable: true,
            cacheable: true,
            version_: "0.0.0",
            animateOnActivation: true)
        
        layer = mapView.mapWindow.map!.addLayer(
            withLayerId: "mapkit_logo",
            contentType: "image/png",
            layerOptions: layerOptions,
            urlProvider: tilesUrlProvider,
            imageUrlProvider: nil,
            projection: projection)
        layer!.invalidate(withVersion: "0.0.0")
    }
}
