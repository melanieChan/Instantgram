//
//  AppDelegate.swift
//  Instantgram
//
//  Created by Melanie Chan on 3/6/21.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // connect to Parse
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "4aBtzXpSGS1pYVUNjly5xX6FpHP2BN4fumekaoSF"
                $0.clientKey = "1fuqjuUHmC3AOl7r5qwomZVaFatOyGmtfyn7wfl6"
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

