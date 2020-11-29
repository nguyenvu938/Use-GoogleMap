//
//  AppDelegate.swift
//  UseGoogleMap
//
//  Created by NguyenVu on 29/11/2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let googleApiKey = "AIzaSyBPyRsfiLJQfRd8Bggv69vyW6E4mkKDUcY"
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        let mapViewController = MapViewController()
        let nav = UINavigationController(rootViewController: mapViewController)
        nav.navigationBar.barTintColor = UIColor(red: 0.26, green: 0.95, blue: 0.62, alpha: 1.00)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }



}
