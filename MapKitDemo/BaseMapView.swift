import UIKit
import YandexMapsMobile

class BaseMapView: UIView {

    @IBOutlet var contentView: UIView!
    @objc public var mapView: YMKMapView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initImpl()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    private func initImpl()
    {
        Bundle.main.loadNibNamed("BaseMapView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        // OpenGl is deprecated under M1 simulator, we should use Vulkan
        mapView = YMKMapView(frame: bounds, vulkanPreferred: BaseMapView.isM1Simulator())
        mapView.mapWindow.map.mapType = .map
        contentView.insertSubview(mapView, at: 0)
    }

    static func isM1Simulator() -> Bool
    {
        return (TARGET_IPHONE_SIMULATOR & TARGET_CPU_ARM64) != 0
    }
}
