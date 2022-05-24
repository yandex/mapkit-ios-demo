import UIKit
import YandexMapsMobile

/**
 * This example shows how to reorder sublayers and use conflict resolving.
 */
class MapSublayersViewController: BaseMapViewController, YMKMapInputListener {

    @IBOutlet var switchSublayersOrderButton: UIButton!
    struct SwitchSublayerOrderButtonTitle {
        static let renderBuildingsAfterMapObjectGeomerty = "Render Buildings after Map Object Geometry"
        static let renderBuildingsBeforeMapObjectGeomerty = "Render Buildings before Map Object Geometry"
    }

    private let CAMERA_TARGET = YMKPoint(latitude: 59.951029, longitude: 30.317181)

    private var map: YMKMap {
        return mapView.mapWindow.map
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switchSublayersOrderButton.setTitle(
            SwitchSublayerOrderButtonTitle.renderBuildingsBeforeMapObjectGeomerty, for: .normal)

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 16, azimuth: 0, tilt: 45))

        let circle = YMKCircle(center: CAMERA_TARGET, radius: 100.0)
        map.mapObjects.addCircle(with: circle, stroke: .red, strokeWidth: 2.0, fill: .white)

        let points = [
            YMKPoint(latitude: 59.949911, longitude: 30.316560),
            YMKPoint(latitude: 59.949121, longitude: 30.316008),
            YMKPoint(latitude: 59.949441, longitude: 30.318132),
            YMKPoint(latitude: 59.950075, longitude: 30.316915),
            YMKPoint(latitude: 59.949911, longitude: 30.316560),
        ]
        let polygon = YMKPolygon(outerRing: YMKLinearRing(points: points), innerRings: [])
        let polygonMapObject = map.mapObjects.addPolygon(with: polygon)
        polygonMapObject.fillColor = UIColor.green.withAlphaComponent(0.16)
        polygonMapObject.strokeWidth = 3.0
        polygonMapObject.strokeColor = .green

        // Example of conflict resolving
        if let sublayerIndex = map.sublayerManager.findFirstOf(
            withLayerId: YMKLayerIds.mapObjectsLayerId(),
            featureType: .placemarksAndLabels)?.uintValue
        {
            let sublayer = map.sublayerManager.getWithSublayerIndex(sublayerIndex)

            // The placemarks and labels from lower sublayers will be displaced in case of conflict
            sublayer?.conflictResolutionMode = .major
        }

        map.addInputListener(with: self)
    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        let animatedImageProvider = YRTAnimatedImageProviderFactory.fromFile(
            Bundle.main.path(forResource: "Animations/animation", ofType: "apng")) as! YRTAnimatedImageProvider
        let iconStyle: YMKIconStyle = YMKIconStyle()
        iconStyle.scale = 4.0
        map.mapObjects.addPlacemark(with: point, animatedImage: animatedImageProvider, style: iconStyle)
    }

    @IBAction func onSwitchSublayersButtonClicked() {
        // Example of changing the order of sublayers
        guard let buildingsSublayerIndex = map.sublayerManager.findFirstOf(
            withLayerId: YMKLayerIds.buildingsLayerId(), featureType: .models)?.uintValue else
        {
            showAlertMessage(message: "Buildings sublayer not found!")
            return
        }

        guard let mapObjectGeometrySublayerIndex = map.sublayerManager.findFirstOf(
            withLayerId: YMKLayerIds.mapObjectsLayerId(), featureType: .ground)?.uintValue else
        {
            showAlertMessage(message: "MapObject ground sublayer not found!")
            return
        }

        if buildingsSublayerIndex < mapObjectGeometrySublayerIndex {
            map.sublayerManager.moveAfterWith(from: buildingsSublayerIndex, to: mapObjectGeometrySublayerIndex)
            switchSublayersOrderButton.setTitle(
                SwitchSublayerOrderButtonTitle.renderBuildingsBeforeMapObjectGeomerty, for: .normal)
        } else {
            map.sublayerManager.moveAfterWith(from: mapObjectGeometrySublayerIndex, to: buildingsSublayerIndex)
            switchSublayersOrderButton.setTitle(
                SwitchSublayerOrderButtonTitle.renderBuildingsAfterMapObjectGeomerty, for: .normal)
        }
    }

    private func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
