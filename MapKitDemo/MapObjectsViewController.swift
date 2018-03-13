import UIKit
import YandexMapKit

/**
 * This example shows how to add simple objects such as polygons, circles and polylines to the map.
 * It also shows how to display images instead.
 */
class MapObjectsViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    
    let CAMERA_TARGET = YMKPoint(latitude: 59.952, longitude: 30.318)
    let ANIMATED_RECTANGLE_CENTER = YMKPoint(latitude: 59.956, longitude: 30.313)
    let TRIANGLE_CENTER = YMKPoint(latitude: 59.948, longitude: 30.313)
    let POLYLINE_CENTER = YMKPoint(latitude: 59.952, longitude: 30.318)
    let CIRCLE_CENTER = YMKPoint(latitude: 59.956, longitude: 30.323)
    let DRAGGABLE_PLACEMARK_CENTER = YMKPoint(latitude: 59.948, longitude: 30.323)
    let OBJECT_SIZE: Double = 0.0015;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMapObjects()
        mapView.mapWindow.map!.move(
            with: YMKCameraPosition.init(target: CAMERA_TARGET, zoom: 15, azimuth: 0, tilt: 0))
    }
    
    func createMapObjects() {
        let mapObjects = mapView.mapWindow.map!.mapObjects!
        let animatedPolygonPoints = [
            YMKPoint(
                latitude: ANIMATED_RECTANGLE_CENTER.latitude - OBJECT_SIZE,
                longitude: ANIMATED_RECTANGLE_CENTER.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: ANIMATED_RECTANGLE_CENTER.latitude - OBJECT_SIZE,
                longitude: ANIMATED_RECTANGLE_CENTER.longitude + OBJECT_SIZE),
            YMKPoint(
                latitude: ANIMATED_RECTANGLE_CENTER.latitude + OBJECT_SIZE,
                longitude: ANIMATED_RECTANGLE_CENTER.longitude + OBJECT_SIZE),
            YMKPoint(
                latitude: ANIMATED_RECTANGLE_CENTER.latitude + OBJECT_SIZE,
                longitude: ANIMATED_RECTANGLE_CENTER.longitude - OBJECT_SIZE)
        ]
        
        let animatedRectangle = mapObjects.addPolygon(
            with: YMKPolygon(outerRing: YMKLinearRing(points: animatedPolygonPoints), innerRings: []))
        animatedRectangle!.fillColor = UIColor.clear
        animatedRectangle!.strokeColor = UIColor.clear
        let animatedImage = YRTAnimatedImageProviderFactory.fromFile(
            Bundle.main.path(forResource: "Animations/animation", ofType: "apng")) as! YRTAnimatedImageProvider
        animatedRectangle!.setAnimatedImageWithAnimatedImage(
            animatedImage, patternWidth: 32, repeatMode: YMKPatternRepeatMode.repeat)
        
        let trianglePoints = [
            YMKPoint(
                latitude: TRIANGLE_CENTER.latitude + OBJECT_SIZE,
                longitude: TRIANGLE_CENTER.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: TRIANGLE_CENTER.latitude - OBJECT_SIZE,
                longitude: TRIANGLE_CENTER.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: TRIANGLE_CENTER.latitude,
                longitude: TRIANGLE_CENTER.longitude + OBJECT_SIZE)
        ]
        
        let triangle = mapObjects.addPolygon(
            with: YMKPolygon(outerRing: YMKLinearRing(points: trianglePoints), innerRings: []))
        triangle!.fillColor = UIColor.blue
        triangle!.strokeColor = UIColor.black
        triangle!.strokeWidth = 1
        triangle!.zIndex = 100
        
        let circle = mapObjects.addCircle(
            with: YMKCircle(center: CIRCLE_CENTER, radius: 100),
            stroke: UIColor.green,
            strokeWidth: 2,
            fill: UIColor.red)
        circle!.zIndex = 100
        
        let polylinePoints = [
            YMKPoint(
                latitude: POLYLINE_CENTER.latitude + OBJECT_SIZE,
                longitude: POLYLINE_CENTER.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: POLYLINE_CENTER.latitude - OBJECT_SIZE,
                longitude: POLYLINE_CENTER.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: POLYLINE_CENTER.latitude,
                longitude: POLYLINE_CENTER.longitude + OBJECT_SIZE)
        ]
        let polyline = mapObjects.addPolyline(with: YMKPolyline(points: polylinePoints))
        polyline!.strokeColor = UIColor.black
        polyline!.zIndex = 100
        
        let placemark = mapObjects.addPlacemark(with: DRAGGABLE_PLACEMARK_CENTER)
        placemark!.opacity = 0.5
        placemark!.isDraggable = true
        placemark!.setIconWith(UIImage(named:"Mark"))
    }
}
