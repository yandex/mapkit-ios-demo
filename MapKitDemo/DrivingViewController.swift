import UIKit
import YandexRuntime
import YandexMapKit

/**
 * This example shows how to build routes between two points and display them on the map.
 * Note: Routing API calls count towards MapKit daily usage limits. Learn more at
 * https://tech.yandex.ru/mapkit/doc/3.x/concepts/conditions-docpage/#conditions__limits
 */
class DrivingViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    var drivingSession: YMKDrivingSession?
    
    let ROUTE_START_POINT = YMKPoint(latitude: 59.959194, longitude: 30.407094)
    let ROUTE_END_POINT = YMKPoint(latitude: 55.733330, longitude: 37.587649)
    let CAMERA_TARGET = YMKPoint(latitude: 57.846262, longitude: 33.997372)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapWindow.map!.move(
            with: YMKCameraPosition(target: CAMERA_TARGET, zoom: 6, azimuth: 0, tilt: 0))
        
        let requestPoints = [
            YMKDrivingRequestPoint(point: ROUTE_START_POINT, arrivalPoints: [], type: YMKDrivingRequestPointType.waypoint),
            YMKDrivingRequestPoint(point: ROUTE_END_POINT, arrivalPoints: [], type: YMKDrivingRequestPointType.waypoint),
        ]
        
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }
        
        let drivingRouter = YMKMapKit.sharedInstance().createDrivingRouter()!
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            routeHandler: responseHandler)
    }
    
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = mapView.mapWindow.map!.mapObjects!
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }
    
    func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
