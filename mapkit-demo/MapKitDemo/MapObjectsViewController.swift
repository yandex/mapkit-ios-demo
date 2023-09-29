import UIKit
import YandexMapsMobile

/**
 * This example shows how to add simple objects such as polygons, circles and polylines to the map.
 * It also shows how to display images instead.
 */
class MapObjectsViewController: BaseMapViewController {

	let OBJECT_SIZE: Double = 0.0015

    private var animationIsActive = true
    private var circleMapObjectTapListener: YMKMapObjectTapListener!

    override func viewDidLoad() {
        super.viewDidLoad()

        createMapObjects()
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: Const.targetLocation, zoom: 15, azimuth: 0, tilt: 0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationIsActive = false
    }

    func createMapObjects() {
        let mapObjects = mapView.mapWindow.map.mapObjects
        let animatedPolygonPoints = [
            YMKPoint(
                latitude: Const.animatedRectangleCenter.latitude - OBJECT_SIZE,
                longitude: Const.animatedRectangleCenter.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: Const.animatedRectangleCenter.latitude - OBJECT_SIZE,
                longitude: Const.animatedRectangleCenter.longitude + OBJECT_SIZE),
            YMKPoint(
                latitude: Const.animatedRectangleCenter.latitude + OBJECT_SIZE,
                longitude: Const.animatedRectangleCenter.longitude + OBJECT_SIZE),
            YMKPoint(
                latitude: Const.animatedRectangleCenter.latitude + OBJECT_SIZE,
                longitude: Const.animatedRectangleCenter.longitude - OBJECT_SIZE)
        ]

        let animatedRectangle = mapObjects.addPolygon(
            with: YMKPolygon(outerRing: YMKLinearRing(points: animatedPolygonPoints), innerRings: []))
        animatedRectangle.fillColor = UIColor.clear
        animatedRectangle.strokeColor = UIColor.clear
        let animatedImage = YRTAnimatedImageProviderFactory.fromFile(
            Bundle.main.path(forResource: "Animations/animation", ofType: "png")) as! YRTAnimatedImageProvider
        animatedRectangle.setPatternWithAnimatedImage(
            animatedImage, scale: 1)

        let trianglePoints = [
            YMKPoint(
                latitude: Const.triangleCenter.latitude + OBJECT_SIZE,
                longitude: Const.triangleCenter.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: Const.triangleCenter.latitude - OBJECT_SIZE,
                longitude: Const.triangleCenter.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: Const.triangleCenter.latitude,
                longitude: Const.triangleCenter.longitude + OBJECT_SIZE)
        ]

        let triangle = mapObjects.addPolygon(
            with: YMKPolygon(outerRing: YMKLinearRing(points: trianglePoints), innerRings: []))
        triangle.fillColor = UIColor.blue
        triangle.strokeColor = UIColor.black
        triangle.strokeWidth = 1
        triangle.zIndex = 100

        createTappableCircle();

        let polylinePoints = [
            YMKPoint(
                latitude: Const.targetLocation.latitude + OBJECT_SIZE,
                longitude: Const.targetLocation.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: Const.targetLocation.latitude - OBJECT_SIZE,
                longitude: Const.targetLocation.longitude - OBJECT_SIZE),
            YMKPoint(
                latitude: Const.targetLocation.latitude,
                longitude: Const.targetLocation.longitude + OBJECT_SIZE)
        ]
        let polyline = mapObjects.addPolyline(with: YMKPolyline(points: polylinePoints))
        polyline.setStrokeColorWith(UIColor.black)
        polyline.zIndex = 100

        let coloredPolyline = mapObjects.addPolyline(with: YMKPolyline(points: Const.coloredPolylinePoints))

        // lets define colors for each polyline segment
        coloredPolyline.setPaletteColorWithColorIndex(0, color: UIColor.yellow)
        coloredPolyline.setPaletteColorWithColorIndex(1, color: UIColor.green)
        coloredPolyline.setPaletteColorWithColorIndex(2, color: UIColor.purple)
        coloredPolyline.setStrokeColorsWithColors([0, 1, 2])

        // Maximum pgradient length in screen points.
        coloredPolyline.gradientLength = 250
        coloredPolyline.strokeWidth = 15
        coloredPolyline.zIndex = 100

        let placemark = mapObjects.addPlacemark()
        placemark.geometry = Const.draggablePlacemarkCenter
        placemark.opacity = 0.5
        placemark.isDraggable = true
        placemark.setIconWith(UIImage(named:"Mark")!)

        createPlacemarkMapObjectWithViewProvider();
        createAnimatedPlacemark();
    }

    private class CircleMapObjectTapListener: NSObject, YMKMapObjectTapListener {
        private weak var controller: UIViewController?

        init(controller: UIViewController) {
            self.controller = controller
        }

        func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
            if let circle = mapObject as? YMKCircleMapObject {
                let randomRadius: Float = 100.0 + 50.0 * Float.random(in: 0..<10);
                let curGeometry = circle.geometry;
                circle.geometry = YMKCircle(center: curGeometry.center, radius: randomRadius);

                if let userData = circle.userData as? CircleMapObjectUserData {
                    let message = "Circle with id \(userData.id) and description '\(userData.description)' tapped";
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
                    alert.view.backgroundColor = UIColor.darkGray;
                    alert.view.alpha = 0.8;
                    alert.view.layer.cornerRadius = 15;

                    controller?.present(alert, animated: true);
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        alert.dismiss(animated: true);
                    }
                }
            }
            return true;
        }
    }

    private class CircleMapObjectUserData {
        let id: Int32;
        let description: String;
        init(id: Int32, description: String) {
            self.id = id;
            self.description = description;
        }
    }

    func createTappableCircle() {
        let mapObjects = mapView.mapWindow.map.mapObjects;
        let circle = mapObjects.addCircle(with: YMKCircle(center: Const.circleCenter, radius: 100))
        circle.strokeColor = UIColor.green
        circle.strokeWidth = 2
        circle.fillColor = UIColor.red
        circle.zIndex = 100
        circle.userData = CircleMapObjectUserData(id: 42, description: "Tappable circle");

        // Client code must retain strong reference to the listener.
        circleMapObjectTapListener = CircleMapObjectTapListener(controller: self);
        circle.addTapListener(with: circleMapObjectTapListener);
    }

    func createPlacemarkMapObjectWithViewProvider() {
        let textView =
            UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30));
        let colors = [UIColor.red, UIColor.green, UIColor.black];

        textView.isOpaque = false;
        textView.backgroundColor = UIColor.clear.withAlphaComponent(0.0);
        textView.text = "Hello, World!";
        textView.textColor = UIColor.red;

        let viewProvider = YRTViewProvider(uiView: textView);

        let viewPlacemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        viewPlacemark.geometry = Const.targetLocation
        viewPlacemark.setViewWithView(viewProvider!)

        let delayToShowInitialText = 5.0;  // seconds
        let delayToShowRandomText = 0.5; // seconds

        // Show initial text `delayToShowInitialText` seconds and then
        // randomly change text in textView every `delayToShowRandomText` seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + delayToShowInitialText) {

            func doMainLoop() {
                if !self.animationIsActive {
                    return
                }

                let randomInt = Int(arc4random_uniform(1000));
                textView.text = "Some text " + String(randomInt);
                textView.textColor = colors[randomInt % colors.count];
                viewProvider?.snapshot();
                viewPlacemark.setViewWithView(viewProvider!);

                DispatchQueue.main.asyncAfter(deadline: .now() + delayToShowRandomText) {
                    doMainLoop()
                }
            }

            doMainLoop();
        }
    }

    func createAnimatedPlacemark() {
        let animatedImageProvider = YRTAnimatedImageProviderFactory.fromFile(
            Bundle.main.path(forResource: "Animations/animation", ofType: "png")) as! YRTAnimatedImageProvider
        let animatedPlacemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        animatedPlacemark.geometry = Const.animatedPlacemarkCenter
        let animation = animatedPlacemark.useAnimation()
        animation.setIconWithImage(animatedImageProvider, style: YMKIconStyle()) {
            animation.play()
        }
    }
}
