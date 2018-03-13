import UIKit
import YandexMapKit

/**
 * This example shows how to add and interact with a layer that displays search results on the map.
 * Note: search API calls count towards MapKit daily usage limits. Learn more at
 * https://tech.yandex.ru/mapkit/doc/3.x/concepts/conditions-docpage/#conditions__limits
 */
class SearchViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    
    internal class SearchResponseHandler: NSObject, YMKResponseHandler {
        var viewController: UIViewController!
        
        required init(_ controller: UIViewController) {
            viewController = controller
        }
        
        func onSearchStart() {}
        
        func onSearchSuccess() {}
        
        func onSearchErrorWithError(_ error: Error?) {
            let searchError = (error as! NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
            var errorMessage = "Unknown error"
            if searchError.isKind(of: YRTNetworkError.self) {
                errorMessage = "Network error"
            } else if searchError.isKind(of: YRTRemoteError.self) {
                errorMessage = "Remote server error"
            }
            
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    var searchResponseHandler: SearchResponseHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResponseHandler = SearchResponseHandler(self)
        mapView.mapWindow.map!.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: 59.945933, longitude: 30.320045), zoom: 14, azimuth: 0, tilt: 0))
        let searchLayer = mapView.mapWindow.map!.searchLayer
        searchLayer!.addSearchResultListener(withSearchResultListener: searchResponseHandler)
        searchLayer!.submitQuery(withQuery: "cafe", searchOptions: YMKSearchOptions())
    }
}
