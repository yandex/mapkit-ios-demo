import UIKit
import YandexMapsMobile

/**
 * This example shows how to build routes between two points and display them on the map.
 * Note: Routing API calls count towards MapKit daily usage limits.
 */
class DrivingViewController: BaseMapViewController {

    var drivingSession: YMKDrivingSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: Const.targetLocation, zoom: 6, azimuth: 0, tilt: 0))

        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: Const.routeStartPoint, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: Const.routeEndPoint, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]

        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }

        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
    }

    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = mapView.mapWindow.map.mapObjects
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
