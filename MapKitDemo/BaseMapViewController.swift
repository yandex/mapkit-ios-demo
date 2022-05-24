import UIKit
import Foundation
import YandexMapsMobile


class BaseMapViewController : UIViewController {
    
    @IBOutlet weak var baseMapView: BaseMapView!
    
    var mapView: YMKMapView! {
        get {
            return baseMapView.mapView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
