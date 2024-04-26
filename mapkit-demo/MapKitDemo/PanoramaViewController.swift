import UIKit
import YandexMapsMobile

/**
 * This example shows how to find a panorama that is nearest to a given point and display it
 * in the PanoramaView object. User is not limited to viewing the panorama found and can
 * use arrows to navigate.
 * Note: Nearest panorama search API calls count towards MapKit daily usage limits.
 */
class PanoramaViewController: UIViewController {
    var panoView: YMKPanoView!
    var panoramaSession: YMKPanoramaServiceSearchSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        panoView = YMKPanoView(frame: self.view.frame, vulkanPreferred: true)
        self.view.addSubview(panoView)

        let responseHandler = {(panoramaIdResponse: String?, error: Error?) -> Void in
            if let panoramaId = panoramaIdResponse {
                self.onPanoramaFound(panoramaId)
            } else {
                self.onPanoramaSearchError(error!)
            }
        }

        let panoramaService = YMKPlacesFactory.instance().createPanoramaService()
        panoramaSession = panoramaService.findNearest(
            withPosition: Const.targetLocation,
            searchHandler: responseHandler)
    }

    func onPanoramaFound(_ panoramaId: String) {
        panoView.player.openPanorama(withPanoramaId: panoramaId)
        panoView.player.enableMove()
        panoView.player.enableRotation()
        panoView.player.enableZoom()
        panoView.player.enableMarkers()
    }

    func onPanoramaSearchError(_ error: Error) {
        let panoramaSearchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError

        var errorMessage = "Unknown error"
        if panoramaSearchError.isKind(of: YMKPanoramaNotFoundError.self) {
            errorMessage = "Not found"
        } else if panoramaSearchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if panoramaSearchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
