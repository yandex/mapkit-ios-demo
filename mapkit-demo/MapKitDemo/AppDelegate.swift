import UIKit
import YandexMapsMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    /**
     * Replace "your_api_key" with a valid developer key.
     * You can get it at the https://developer.tech.yandex.ru/ website.
     */
    let MAPKIT_API_KEY = "your_api_key"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /**
         * Set API key before interaction with MapKit.
         */
        YMKMapKit.setApiKey(MAPKIT_API_KEY)

        /**
         * You can optionaly customize  locale.
         * Otherwise MapKit will use default location.
         */
        YMKMapKit.setLocale("en_US")
        
        /**
         * If you create instance of YMKMapKit not in application:didFinishLaunchingWithOptions: 
         * you should also explicitly call YMKMapKit.sharedInstance().onStart()
         */
        YMKMapKit.sharedInstance()

        return true
    }
}
