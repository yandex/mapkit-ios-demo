import UIKit
import YandexMapsMobile

class MasstransitRoutingViewController : BaseMapViewController {
    
    private var router: YMKMasstransitRouter? = nil
    private var masstransitSession: YMKMasstransitSession? = nil
    private var mapObjects: YMKMapObjectCollection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapObjects = mapView.mapWindow.map.mapObjects
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: Const.masstransitPoint, zoom: 12, azimuth: 0, tilt: 0))
        
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: Const.masstransitRouteStartLocation, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: Const.masstransitRouteEndLocation, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]

        let responseHandler = {(routesResponse: [YMKMasstransitRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else if let error = error {
                self.onRoutesError(error)
            }
        }
        
        let options = YMKTransitOptions(avoid: YMKFilterVehicleTypes(rawValue: 0), timeOptions: YMKTimeOptions())
        
        router = YMKTransportFactory.instance().createMasstransitRouter()
        masstransitSession = router?.requestRoutes(with: requestPoints, transitOptions: options, avoidSteep: false, routeHandler: responseHandler)
    }
    
    private func onRoutesReceived(_ routes: [YMKMasstransitRoute]) {
        for section in routes.first!.sections {
            let subpolyline = YMKSubpolylineHelper.subpolyline(with: routes.first!.geometry, subpolyline: section.geometry)
            drawSection(section.metadata.data , geometry: subpolyline)
        }
    }

    private func onRoutesError(_ error: Error) {
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
    
    private func drawSection(_ data: YMKMasstransitSectionMetadataSectionData, geometry: YMKPolyline) {
        // Draw a section polyline on a map
        // Set its color depending on the information which the section contains
        let polylineMapObject = mapObjects!.addPolyline(with: geometry)
        // Masstransit route section defines exactly one on the following
        // 1. Wait until public transport unit arrives
        // 2. Walk
        // 3. Transfer to a nearby stop (typically transfer to a connected
        //    underground station)
        // 4. Ride on a public transport
        // Check the corresponding object for null to get to know which
        // kind of section it is
        if let transports = data.transports {
            // A ride on a public transport section contains information about
            // all known public transport lines which can be used to travel from
            // the start of the section to the end of the section without transfers
            // along a similar geometry
            for transport in transports {
                // Some public transport lines may have a color associated with them
                // Typically this is the case of underground lines
                if transport.line.style != nil {
                    polylineMapObject.setStrokeColorWith(Const.undergroundStrokeColor)
                    return;
                }
            }
            // Let us draw bus lines in green and tramway lines in red
            // Draw any other public transport lines in blue
            let knownVehicleTypes = Set(["bus", "tramway"]);
            for transport in transports {
                let sectionVehicleType = getKnownVehicleType(transport, knownVehicleTypes)
                switch sectionVehicleType {
                case "bus":
                    polylineMapObject.setStrokeColorWith(Const.busStrokeColor);
                    return;
                case "tramway":
                    polylineMapObject.setStrokeColorWith(Const.tramwayStrokeColor);
                    return;
                default:
                    continue
                }
            }

            polylineMapObject.setStrokeColorWith(Const.publicTransportStrokeColor);
        } else {
            // This is not a public transport ride section
            // In this example let us draw it in black
            polylineMapObject.setStrokeColorWith(Const.nonPublicTransportStrokeColor);
        }
    }
    
    private func getKnownVehicleType(_ transport: YMKMasstransitTransport, _ knownVehicleTypes: Set<String>) -> String? {
        // A public transport line may have a few 'vehicle types' associated with it
        // These vehicle types are sorted from more specific (say, 'histroic_tram')
        // to more common (say, 'tramway').
        // Your application does not know the list of all vehicle types that occur in the data
        // (because this list is expanding over time), therefore to get the vehicle type of
        // a public line you should iterate from the more specific ones to more common ones
        // until you get a vehicle type which you can process
        // Some examples of vehicle types:
        // "bus", "minibus", "trolleybus", "tramway", "underground", "railway"
        return transport.line.vehicleTypes.first(where: { knownVehicleTypes.contains($0) })
    }
}
