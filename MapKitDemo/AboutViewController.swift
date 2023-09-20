import Foundation
import YandexMapsMobile

class AboutViewController : UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text += YMKMapKit.sharedInstance().version
    }
}
