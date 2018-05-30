import UIKit
import CoreLocation

class MainTabBarController: UITabBarController /*, ModelDelegate */{
 /*   func errorUpdating(error: NSError) {
        print("errore load data from cloudkit")
    }
    
    func modelUpdated() {
        print("load data from cloudkit complete!")
    }
    
    var modelAdvertisement = AdvertisementModel.shared
    var modelBusinessLocal = BusinessLocalModel.shared
*/
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*        self.modelAdvertisement.delegate = self
        self.modelBusinessLocal.delegate = self
        modelBusinessLocal.loadBusinessLocals()
        modelAdvertisement.loadAdvertisementByRange(position: CLLocation(latitude: 40.5122, longitude: 14.1447), distance: 10)
 */
        selectedIndex = defaultIndex
        self.tabBar.unselectedItemTintColor = UIColor.white
//   self.tabBar.items![4].isEnabled = false
        
    }

}
