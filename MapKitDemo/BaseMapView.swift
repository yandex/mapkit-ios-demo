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
        mapView = YMKMapView(frame: bounds, vulkanPreferred: true)
        mapView.mapWindow.map.mapType = .vectorMap
        contentView.insertSubview(mapView, at: 0)
    }
}
