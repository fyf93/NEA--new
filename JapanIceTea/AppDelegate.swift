

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ModelDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
   //GM
    func errorUpdating(error: NSError) {
        print("errore load data from cloudkit")
    }
    
    func modelUpdated() {
        print("load data from cloudkit complete!")
    }
    
    var modelAdvertisement = AdvertisementModel.shared
    var modelBusinessLocal = BusinessLocalModel.shared
    var modelMessage = MessageModel.shared
    
    //end GM
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      //GM
        self.modelAdvertisement.delegate = self
        self.modelBusinessLocal.delegate = self
        modelBusinessLocal.loadBusinessLocals()
       // modelAdvertisement.loadAdvertisementByRange(position: CLLocation(latitude: 40.5122, longitude: 14.1447), distance: 10)
        //modelMessage.deleteAllMessages()
        
       //end GM
        var userID = String()
        iCloudUserIDAsync() {
            recordID, error in
            if (recordID != nil) {
                userID = (recordID?.recordName)!
                print("received iCloudID \(userID)")
                UserSingleton.shared.id = userID
                
            } else {
                print("Fetched iCloudID was nil")
            }
        }
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
            CKContainer.default().fetchUserRecordID { (record, error) in
                CKContainer.default().discoverUserIdentity(withUserRecordID: record!, completionHandler: {
                    (userIdentity, error) in
                    
                    var nome = userIdentity?.nameComponents?.givenName?.capitalized
                    // self.camelCaseString(source: (userIdentity?.nameComponents?.givenName)!)
                    var cognome = userIdentity?.nameComponents?.familyName?.capitalized
                    //self.camelCaseString(source: (userIdentity?.nameComponents?.familyName)!)
                    UserSingleton.shared.name = nome!+cognome!
                    //print("givenName=\(userIdentity?.nameComponents?.givenName)")
                    //print("familyName=\(userIdentity?.nameComponents?.familyName)")
                    print("nome utente = \(UserSingleton.shared.name)")
                    
                    print("device=\(UIDevice.current.name)")
                    UserSingleton.shared.device = UIDevice.current.name
                    
                  //  var model = MessageModel()
                    //  model.sendMessage(messaggio: "messaggio ricevutoa", mittente: UserSingleton.shared.name+"-"+UserSingleton.shared.id , destinatario: "B9BF4C21-D02A-404C-8210-6230C2B99BC1")
                })
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        })
        
        //***********/
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        /*************/
        // Override point for customization after application launch.
        return true
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let message = note(fromRegionIdentifier: region.identifier) else { return }
            window?.rootViewController?.showAlert(withTitle: nil, message: message)
            print("alert \(message)")
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = note(fromRegionIdentifier: region.identifier)
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func note(fromRegionIdentifier identifier: String) -> String? {
        let savedItems = UserDefaults.standard.array(forKey: "savedItems") as? [NSData]
        let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let index = geotifications?.index { $0?.identifier == identifier }
        return index != nil ? geotifications?[index!]?.note : nil
    }
    
    /// async gets iCloud record ID object of logged-in iCloud user
    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecordID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
            } else {
                //print("fetched ID \(recordID?.recordName)")
                complete(recordID, nil)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var destinatario = String()
        if (OwnerSingleton.ID.isEmpty)
        {
            while (UserSingleton.shared.name == "")
            {
            }
            print("notification=\(UserSingleton.shared.name)")
            
            destinatario = UserSingleton.shared.name+"_"+UserSingleton.shared.id
        }
        else
        {
            destinatario = OwnerSingleton.businessLocals[OwnerSingleton.idxBusinessLocalSelected].record.recordID.recordName
            
        }
        
        let subscription = CKQuerySubscription(recordType: "Message", predicate: NSPredicate(format: "destinatario == %@", destinatario) /* NSPredicate(format: "TRUEPREDICATE")*/, options: .firesOnRecordCreation)
        
        let info = CKNotificationInfo()
        info.alertBody = "Nuovo messagio da NEA!"
        info.shouldBadge = true
        info.soundName = "default"
        
        subscription.notificationInfo = info
        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                print("subscript saved successfully")
                // Subscription saved successfully
            } else {
                print("error in saved:\(error)" )
                // An error occurred
            }
        })
        
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
            print("notifico al viewcontroller")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadConversation"), object: nil)
            completionHandler([.alert, .sound])
            
        })
        
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("Recived: \(userInfo)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadConversation"), object: nil)
        completionHandler(.newData)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
        
    }
}


