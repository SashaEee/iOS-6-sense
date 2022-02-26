//
//  AppDelegate.swift
//  6 Sense
//
//  Created by Sasha on 8/18/21.
//

import UIKit
import Alamofire
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GetDataLocations()
        // Override point for customization after application launch.
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
    func GetDataLocations(){
        let url = "https://feel.sfedu.ru/hestia/api/location/?format=json"
        AF.request(url, method: .get).responseData { [self] response in
            switch response.result {
            case .success(_):
                JSON1 = JSON(response.value!)
//                print(JSON1![0])
                let beaconJSON = BeaconName(fromJson: JSON1![0]) //парсинг
                if (beaconJSON.name != nil){
//                speakingText(nameBeacon: beaconJSON.name)
                }
                print("Получение данных завершено")
                case .failure(_):
                print("Ошибка при запросе данных \(String(describing: response.error))")
                return
            }
        }
    }



}

