//
//  LocationsViewController.swift
//  6 Sense
//
//  Created by Sasha on 2/17/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation


var JSON1: JSON?
var infoButtonLoc: Int = 0


class DynamicStackViewController: UIViewController, CLLocationManagerDelegate { //страница с локациями
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var myButtonsArray : [String] = []
    var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        addButton()
        buttonsStack.spacing = 10
        let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        super.viewDidLoad()
                
        
    } //End ViewDidload
    
    @IBAction func buttonAction(sender: UIButton!) { // нажата одна из кнопок
        infoButtonLoc = sender.tag
        openView(id: "LocationView")
        print("Button tapped with tag \(sender.tag)")
    }
    func openView(id: String){ // переход на некст страницу
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: id)
        self.navigationController?.show(nextVC, sender: Any?.self)
    }
    
    func addButton(){
        for index in JSON1!.array!.startIndex...JSON1!.array!.endIndex - 1 {
            let beaconJSON = BeaconName(fromJson: JSON1![index])
//            print(beaconJSON.text)
            myButtonsArray.append("\(beaconJSON.name ?? "")")
                print(beaconJSON.name)

//            if beaconJSON.text as! String != "" {
//            myButtonsArray.append("\(beaconJSON.name ?? "")")
////                print(beaconJSON.name)
//            } else {
//                myButtonsArray.append("nil")
//                print(beaconJSON.name)
//
//            }
        }
        for (index,element) in myButtonsArray.enumerated() {
            if element != "nil"{
            let oneBtn : UIButton = {
                let button = UIButton()
                button.setTitle(element, for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(UIColor.black, for: .normal)
                //button.translatesAutoresizingMaskIntoConstraints = false
                button.contentHorizontalAlignment = .center
                button.contentVerticalAlignment = .center
                button.titleLabel?.font = UIFont(name: "Fira Code Regular", size: 61)
//                button.layer.cornerRadius = 5
                button.titleLabel?.numberOfLines = 2
                button.titleLabel?.textAlignment = .center
                button.heightAnchor.constraint(equalToConstant: 150).isActive = true
//                button.frame.size.height = 200.0
//                button.frame.size.width = 200.0
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.tag = index
                button.addShadow()
                return button
            }()
            buttonsStack.addArrangedSubview(oneBtn)
            }
        }

    }
    @IBAction func exit(_ sender: Any) { //выходим
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "menu")
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorized { // вызываем геолокацию
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    func startScanning() { //сканируем метки
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")! //01122334-4556-6778-899A-ABBCCDDEEFF0
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")! //01122334-4556-6778-899A-ABBCCDDEEFF0
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "")
        if beacons.count > 0 {
            let macString = generateMac(major: Int32(beacons[0].major.uint32Value), minor: Int32(beacons[0].minor.uint32Value)) //генерируем Mac-адрес метки
            let namePlace = SearchInJSON(macLoc: macString)
            print(namePlace)
            SearchButton(namePlace: namePlace)
            self.locationManager.stopMonitoring(for: beaconRegion)
            self.locationManager.stopRangingBeacons(in: beaconRegion)
            
        } else {
//            updateDistance(.unknown)
        }
    }
    
    func SearchInJSON(macLoc: String) -> String { // поиск в JSON
        var namePlace = ""
        for index in JSON1!.array!.startIndex...JSON1!.array!.endIndex - 1 {
            let beaconJSON = BeaconName(fromJson: JSON1![index])
            for a in beaconJSON.nodes!.startIndex...beaconJSON.nodes!.endIndex - 1{
                let macJSON = beaconJSON.nodes[a].beacon.mac
                if macJSON == macLoc{   namePlace = beaconJSON.name }
            }
        }
        return namePlace
    }
    func SearchButton(namePlace: String){ // поиск кнопки
        for index in myButtonsArray.startIndex...myButtonsArray.endIndex - 1{
            if myButtonsArray[index] == namePlace{
                infoButtonLoc = index
                openView(id: "LocationView")
                print("Button tapped with tag \(index)")
            }
        }
    }

    
        func generateMac(major: Int32, minor: Int32) -> String{ // генерируем мак адрес
            print(major)
            print(minor)
            var a = Array(String(major, radix: 16).uppercased())
            var b = Array(String(minor, radix: 16).uppercased())
            print(b.count)
            print(a.count)
            while(b.count != 4){
                var num = 0
                b.insert("0", at: num)
                num += 1
            }
            while(a.count != 4){
                var num = 0
                a.insert("0", at: num)
                num += 1
            }
            let Str = "\(a[0])" + "\(a[1])" + ":" + "\(a[2])" + "\(a[3])" + ":" + "\(b[0])" + "\(b[1])" + ":" + "\(b[2])" + "\(b[3])"
            return Str
        }



    
}
