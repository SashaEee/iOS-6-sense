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


class BeaconNavigateViewController: UIViewController, CLLocationManagerDelegate { //страница построения маршрута
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
    func printInfo(){ // выводим данные о метке
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
    func startScanning() { //сканируем метки
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")! //a196c876-de8c-4c47-ab5a-d7afd5ae7127 //01122334-4556-6778-899A-ABBCCDDEEFF0 //00000000-0000-0000-0000-000000000000
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) { //определяем ближайщую метку

        var closestBeacon: CLBeacon? = nil
        for beacon in beacons {
          if closestBeacon == nil || (beacon.rssi < 0 && beacon.rssi > closestBeacon!.rssi) {
              if beacon.rssi != 0 {
                  closestBeacon = beacon as? CLBeacon
              }
          }
        }
        print("Ближайшая новая \(closestBeacon)")

        if ((closestBeacon != nil) && ((closestBeacon!.proximity == .immediate) || (closestBeacon!.proximity == .near))){
            updateDistance(closestBeacon!.proximity)
            let macString = generateMac(major: Int32(closestBeacon!.major.uint32Value), minor: Int32(closestBeacon!.minor.uint32Value)) //генерируем Mac-адрес метки
            updateKnown(Str: macString) //проверяем новая ли метка отсканирована
            if known == 0 {
//                GetData(mac: macString)
                FindBeacon(mac: macString)
                print(macString)
            }
        } else {
            updateDistance(.unknown)
        }
    }
    func updateKnown(Str: String){ //обновляем познания
            if (Str != last){
                last = Str
                known = 0
            }
            else {
                known = 1
            }
    }
    
        func generateMac(major: Int32, minor: Int32) -> String{ //генерируем мак адрес
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
            func GetData(mac: String){ //находим метку на сервере
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

    func updateDistance(_ distance: CLProximity) { // обновляем дистанцию до метки))))))))))))))
//        UIView.animate(withDuration: 0.8) {
//            switch distance {
//            case .unknown:
//                self.view.backgroundColor = UIColor.gray
//
//            case .far:
//                self.view.backgroundColor = UIColor.blue
//
//            case .near:
//                self.view.backgroundColor = UIColor.orange
//
//            case .immediate:
//                self.view.backgroundColor = UIColor.red
//            @unknown default:
//                self.view.backgroundColor = UIColor.gray
//            }
//        }
    }
    func GetAllRoute(){ //функция получения маршшрута
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
    func FindRoad(){ // ищем кратчайший маршрут
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
    
    func FindTextRoad(){ // находим что будет проговариваться
        if startBeacon != endBeacon{
            let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
            for index in nodesJSON.edges!.startIndex...nodesJSON.edges!.endIndex-1{
                let edge = nodesJSON.edges[index]
                if (marchrut[0] == edge.start) && (marchrut[1] == edge.stop){
                    speak(phrase: edge.text)
                    print(edge.text)
                    let a = FindPhantom()
                }
            }
        } else {  speak(phrase: "Вы дошли до конечной точки!")  }
    }
    func FindPhantom() -> Bool{
        var phantomIs = 0
        var i = 1
        var k = 2
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        if marchrut.count > 2{
            while (k <= marchrut.endIndex - 1){
                for index in nodesJSON.nodes!.startIndex...nodesJSON.nodes!.endIndex-1{
                    if(k <= marchrut.endIndex - 1){
                        if (nodesJSON.nodes[index].id == marchrut[k]){
                            if  (nodesJSON.nodes[index].beacon.mac == "PHANTOM#"){
                                FindTextRoadCon(st: i, en: k)
                                i += 1
                                k += 1
                            } else {
                                return false
                            }
                        }
                    } else {  break  }
                }
            }
        }
        return true
    }
    func FindTextRoadCon(st: Int, en: Int){
        if startBeacon != endBeacon{
            let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
            for index in nodesJSON.edges!.startIndex...nodesJSON.edges!.endIndex-1{
                let edge = nodesJSON.edges[index]
                if (marchrut[st] == edge.start) && (marchrut[en] == edge.stop){
                    speakPhantom(phrase: edge.text)
                    print(edge.text)
                }
            }
        } else {  speak(phrase: "Вы дошли до конечной точки!")  }
    }
    @IBAction func exit(_ sender: Any) { //выходим
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "menu")
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }

}
