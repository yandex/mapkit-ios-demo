import UIKit
import Foundation
import YandexMapKit

/**
 * This is a basic example that displays a map and sets camera focus on the target location.
 * You need to specify your API key in the AppDelegate.swift file before working with the map.
 * Note: When working on your projects, remember to request the required permissions.
 */
class MapViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    
    let TARGET_LOCATION = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
}
