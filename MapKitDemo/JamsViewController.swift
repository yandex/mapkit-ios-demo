import UIKit
import YandexMapsMobile

/**
 * This example shows how to add layer traffic on the map.
 */
class JamsViewController: BaseMapViewController, YMKMapCameraListener, YMKTrafficDelegate {

    @IBOutlet weak var trafficButton: UISwitch!
    @IBOutlet weak var trafficLabel: UILabel!
    var trafficLayer : YMKTrafficLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trafficLayer = YMKMapKit.sharedInstance().createTrafficLayer(with: mapView.mapWindow)
        trafficLayer.addTrafficListener(withTrafficListener: self)
        mapView.mapWindow.map.addCameraListener(with: self)
        
        mapView.mapWindow.map.move(with: YMKCameraPosition(
            target: YMKPoint(latitude: 59.945933, longitude: 30.320045),
            zoom: 14,
            azimuth: 0,
            tilt: 0))
        
        onSwitchTraffic(self)
    }
    
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
    }
    
    @IBAction func onSwitchTraffic(_ sender: Any) {
        if trafficButton.isOn {
            trafficLabel.text = "0"
            trafficLabel.backgroundColor = UIColor.white
            trafficLayer.setTrafficVisibleWithOn(true)
        } else {
            trafficLabel.text = ""
            trafficLabel.backgroundColor = UIColor.gray
            trafficLayer.setTrafficVisibleWithOn(false)
        }
    }
    
    func onTrafficChanged(with trafficLevel: YMKTrafficLevel?) {
        if trafficLevel == nil {
            return
        }
        trafficLabel.text = String(trafficLevel!.level)
        switch trafficLevel!.color {
        case YMKTrafficColor.red:
            trafficLabel.backgroundColor = UIColor.red
            break
        case YMKTrafficColor.green:
            trafficLabel.backgroundColor = UIColor.green
            break
        case YMKTrafficColor.yellow:
            trafficLabel.backgroundColor = UIColor.yellow
            break
        default:
            trafficLabel.backgroundColor = UIColor.white
            break
        }
    }
    
    func onTrafficLoading() {
        
    }
    
    func onTrafficExpired() {
        
    }
}
