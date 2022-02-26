//
//  BeaconNavigateViewController.swift
//  6 Sense
//
//  Created by Sasha on 2/26/22.
//

import UIKit
import CoreLocation
import AVKit
import Alamofire
import SwiftyJSON

class BeaconNavigateViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var known: Int = 0
    var last: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        printInfo()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

    }
    func printInfo(){
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        let node = nodesJSON.nodes[infoButtonInLoc]
        print("Данные о конечной метки")
        print("Мак адрес метки \(node.beacon.mac ?? "")")
        print("Id метки \(node.beacon.id ?? 0)")
        print("Название метки \(node.beacon.name ?? "")")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    func startScanning() {
        let uuid = UUID(uuidString: "01122334-4556-6778-899A-ABBCCDDEEFF0")! //01122334-4556-6778-899A-ABBCCDDEEFF0
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
            let macString = generateMac(major: Int32(beacons[0].major.uint32Value), minor: Int32(beacons[0].minor.uint32Value)) //генерируем Mac-адрес метки
            updateKnown(Str: macString) //проверяем новая ли метка отсканирована
            print(macString)
            if known == 0 {
                GetData(mac: macString)
            }
            print(beacons[0])
        } else {
            updateDistance(.unknown)
        }
    }
    func updateKnown(Str: String){
            if (Str != last){
                last = Str
                known = 0
            }
            else {
                known = 1
            }
    }
    
        func generateMac(major: Int32, minor: Int32) -> String{
            let a = Array(String(major, radix: 16).uppercased())
            let b = Array(String(minor, radix: 16).uppercased())
            let Str = "\(a[0])" + "\(a[1])" + ":" + "\(a[2])" + "\(a[3])" + ":" + "\(b[0])" + "\(b[1])" + ":" + "\(b[2])" + "\(b[3])"
            return Str
        }
            func GetData(mac: String){
                let url = "https://feel.sfedu.ru/hestia/api/location/?format=json" + mac //"35:7C:9A:35"
                AF.request(url, method: .get).responseData { [self] response in
                    switch response.result {
                    case .success(_):
                        let json = JSON(response.value!)
                        print(json[0])
                        let beaconJSON = BeaconClass(fromJson: json[0]) //парсинг
                        if (beaconJSON.name != nil){
                        speak(phrase: beaconJSON.name)
                        }
                    case .failure(_):
                        print("Ошибка при запросе данных \(String(describing: response.error))")
                        return
                    }
                }
            }

    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray

            case .far:
                self.view.backgroundColor = UIColor.blue

            case .near:
                self.view.backgroundColor = UIColor.orange

            case .immediate:
                self.view.backgroundColor = UIColor.red
            @unknown default:
                self.view.backgroundColor = UIColor.gray
            }
        }
    }



}
