import UIKit

class MainMenuTableViewController: UITableViewController {
    
    #if FULL_VERSION
    let STORYBOARDS = [
        "About",
        "Map",
        "MapObjects",
        "Customization",
        "Driving",
        "UserLocation",
        "Search",
        "Suggest",
        "Panorama",
        "CustomLayer",
        "Clustering",
        "Jams",
        "MapSelection"]
    #else
    let STORYBOARDS = [
        "About",
        "Map",
        "MapObjects",
        "Customization",
        "UserLocation",
        "CustomLayer",
        "Clustering",
        "Jams",
        "MapSelection"]
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboardName = STORYBOARDS[indexPath.row]
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.navigationController!.pushViewController(initialViewController!, animated: true)
    }
}
