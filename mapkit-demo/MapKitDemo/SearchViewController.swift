import UIKit
import YandexMapsMobile

/**
 * This example shows how to add and interact with a layer that displays search results on the map.
 * Note: search API calls count towards MapKit daily usage limits.
 */
class SearchViewController: BaseMapViewController, YMKMapCameraListener {

    var searchManager: YMKSearchManager?
    var searchSession: YMKSearchSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)

        mapView.mapWindow.map.addCameraListener(with: self)

        mapView.mapWindow.map.move(with: YMKCameraPosition(
            target: Const.targetLocation,
            zoom: 14,
            azimuth: 0,
            tilt: 0))
    }

    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
        if finished {
            let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
                if let response = searchResponse {
                    self.onSearchResponse(response)
                } else {
                    self.onSearchError(error!)
                }
            }

            searchSession = searchManager!.submit(
                withText: "cafe",
                geometry: YMKVisibleRegionUtils.toPolygon(with: map.visibleRegion),
                searchOptions: YMKSearchOptions(),
                responseHandler: responseHandler)
        }
    }

    func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        for searchResult in response.collection.children {
            if let point = searchResult.obj?.geometry.first?.point {
                mapObjects.addPlacemark() {
                    $0.geometry = point
                    $0.setIconWith(UIImage(named: "SearchResult")!)
                }
            }
        }
    }

    func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
