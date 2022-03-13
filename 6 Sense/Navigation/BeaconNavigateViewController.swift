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

var endBeaconText: String = ""


class BeaconNavigateViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var buttonWithEndBeacon: UIButton!
    var graph = Graph<String>()
    var locationManager: CLLocationManager!
    var known: Int = 0
    var last: String = ""
    var startBeacon: String = ""
    var endBeacon: String = ""
    var marchrut: [Int] = []
    
    override func viewDidLoad() {
        buttonWithEndBeacon.addShadow()
        buttonWithEndBeacon.titleLabel?.text = endBeaconText
        graph.clear()
        super.viewDidLoad()
        printInfo()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        GetAllRoute()
    }
    func printInfo(){
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        let node = nodesJSON.nodes[infoButtonInLoc]
        endBeacon = String(node.id)
        print("Данные о конечной метки")
        print("Мак адрес метки \(node.beacon.mac ?? "")")
        print("Id метки \(node.beacon.id ?? 0)")
        print("Название метки \(node.beacon.name ?? "")")
        print("Номер метки \(endBeacon)")
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
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")! //01122334-4556-6778-899A-ABBCCDDEEFF0 //01122334-4556-6778-899A-ABBCCDDEEFF0
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons.first!.proximity)
            let macString = generateMac(major: Int32(beacons.first!.major.uint32Value), minor: Int32(beacons.first!.minor.uint32Value)) //генерируем Mac-адрес метки
            updateKnown(Str: macString) //проверяем новая ли метка отсканирована
            if known == 0 {
//                GetData(mac: macString)
                FindBeacon(mac: macString)
                print(macString)
            }
            print(beacons)
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
//                        startBeacon = beaconJSON
//                        FindRoad()
                        }
                    case .failure(_):
                        print("Ошибка при запросе данных \(String(describing: response.error))")
                        return
                    }
                }
            }
    func FindBeacon(mac: String){
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        for index in nodesJSON.nodes!.startIndex...nodesJSON.nodes!.endIndex-1{
            let macJson = nodesJSON.nodes[index].beacon.mac
            if macJson == mac{
                startBeacon = String(nodesJSON.nodes[index].id)
                print("Начальная метка \(startBeacon)")
                if (nodesJSON.nodes[index].textBroadcast != ""){
                    speak(phrase: nodesJSON.nodes[index].textBroadcast)
                    print(nodesJSON.nodes[index].textBroadcast)
                }
                FindRoad()
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
    func GetAllRoute(){
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        for index in nodesJSON.nodes!.startIndex...nodesJSON.nodes!.endIndex-1{
            let node = nodesJSON.nodes![index]
            let result = graph.addNode(with: String(node.id))
            result.onExpected { node in
                print(node) // "A"
            }

        }
        for index in nodesJSON.edges!.startIndex...nodesJSON.edges!.endIndex-1{
            let edge = nodesJSON.edges![index]
            let wrong = graph.addEdge(from: String(edge.start), to: String(edge.stop), weight: Double(edge.weight))
            print(wrong.isExpected) // true
        }
    }
    func FindRoad(){
        marchrut = []
        var shortestPathResult = graph.shortestPath(from: startBeacon, to: endBeacon)
        shortestPathResult.onExpected { path in
            for index in path.nodeData.startIndex...path.nodeData.endIndex-1{
                print("\(path.nodeData[index].node)") // [A] -20.0- [B]
                marchrut.append(Int(path.nodeData[index].node)!)
            }
        }
        FindTextRoad()
    }
    
    func FindTextRoad(){
        if startBeacon != endBeacon{
            let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
            for index in nodesJSON.edges!.startIndex...nodesJSON.edges!.endIndex-1{
                let edge = nodesJSON.edges[index]
                if (marchrut[0] == edge.start) && (marchrut[1] == edge.stop){
                    speak(phrase: edge.text)
                    print(edge.text)
                }
            }
        } else {  speak(phrase: "Вы дошли до конечной точки!")  }
    }
    @IBAction func exit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "menu")
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }

}
