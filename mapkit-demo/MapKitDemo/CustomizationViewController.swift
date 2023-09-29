import UIKit
import Foundation
import YandexMapsMobile

/**
 * This is a basic example that displays a map and sets camera focus on the target location.
 * You need to specify your API key in the AppDelegate.swift file before working with the map.
 * Note: When working on your projects, remember to request the required permissions.
 */
class CustomizationViewController: BaseMapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(with: YMKCameraPosition(target: Const.targetLocation, zoom: 15, azimuth: 0, tilt: 0))
        mapView.mapWindow.map.setMapStyleWithStyle(CustomizationViewController.style())
    }

    private static func style() -> String {
        return CustomizationViewController.readRawJson(resourceName: "customization_example")!
    }

    private static func readRawJson(resourceName: String) -> String? {
        if let filepath: String = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                NSLog("JsonError: Contents could not be loaded from json file: " + resourceName)
                return nil
            }
        } else {
            NSLog("JsonError: json file not found: " + resourceName)
            return nil
        }
    }
}
