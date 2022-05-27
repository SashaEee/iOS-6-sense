//
//  Classes.swift
//  6 Sense
//
//  Created by Sasha on 2/18/22.
//

import Foundation
import SwiftyJSON

class BeaconName : NSObject, NSCoding{ // класс с характеристиками маршрута

    var azimuth : AnyObject!
    var edges : [EdgeClass]!
    var id : Int!
    var isOldTurns : Bool!
    var name : String!
    var nodes : [NodeClass]!
    var text : AnyObject!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        azimuth = json["azimuth"].stringValue as AnyObject
        edges = [EdgeClass]()
        let edgesArray = json["edges"].arrayValue
        for edgesJson in edgesArray{
            let value = EdgeClass(fromJson: edgesJson)
            edges.append(value)
        }
        id = json["id"].intValue
        isOldTurns = json["is_old_turns"].boolValue
        name = json["name"].stringValue
        nodes = [NodeClass]()
        let nodesArray = json["nodes"].arrayValue
        for nodesJson in nodesArray{
            let value = NodeClass(fromJson: nodesJson)
            nodes.append(value)
        }
        text = json["text"].stringValue as AnyObject
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if azimuth != nil{
            dictionary["azimuth"] = azimuth
        }
        if edges != nil{
            var dictionaryElements = [[String:Any]]()
            for edgesElement in edges {
                dictionaryElements.append(edgesElement.toDictionary())
            }
            dictionary["edges"] = dictionaryElements
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isOldTurns != nil{
            dictionary["is_old_turns"] = isOldTurns
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nodes != nil{
            var dictionaryElements = [[String:Any]]()
            for nodesElement in nodes {
                dictionaryElements.append(nodesElement.toDictionary())
            }
            dictionary["nodes"] = dictionaryElements
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         azimuth = aDecoder.decodeObject(forKey: "azimuth") as? AnyObject
         edges = aDecoder.decodeObject(forKey: "edges") as? [EdgeClass]
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isOldTurns = aDecoder.decodeObject(forKey: "is_old_turns") as? Bool
         name = aDecoder.decodeObject(forKey: "name") as? String
         nodes = aDecoder.decodeObject(forKey: "nodes") as? [NodeClass]
         text = aDecoder.decodeObject(forKey: "text") as? AnyObject

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if azimuth != nil{
            aCoder.encode(azimuth, forKey: "azimuth")
        }
        if edges != nil{
            aCoder.encode(edges, forKey: "edges")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isOldTurns != nil{
            aCoder.encode(isOldTurns, forKey: "is_old_turns")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if nodes != nil{
            aCoder.encode(nodes, forKey: "nodes")
        }
        if text != nil{
            aCoder.encode(text, forKey: "text")
        }

    }

}



class NodeClass : NSObject, NSCoding{ // класс с основной ифной о метках

    var beacon : BeaconInfo!
    var coordinateX : Int!
    var coordinateY : Int!
    var id : Int!
    var isDestination : Bool!
    var isPhantom : Bool!
    var isTurnsVerbose : Bool!
    var name : String!
    var text : String!
    var textBroadcast : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let beaconJson = json["beacon"]
                if !beaconJson.isEmpty{
                    beacon = BeaconInfo(fromJson: beaconJson)
                }
        coordinateX = json["coordinate_x"].intValue
        coordinateY = json["coordinate_y"].intValue
        id = json["id"].intValue
        isDestination = json["is_destination"].boolValue
        isPhantom = json["is_phantom"].boolValue
        isTurnsVerbose = json["is_turns_verbose"].boolValue
        name = json["name"].stringValue
        text = json["text"].stringValue
        textBroadcast = json["text_broadcast"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if beacon != nil{
            dictionary["beacon"] = beacon.toDictionary()
        }
        if coordinateX != nil{
            dictionary["coordinate_x"] = coordinateX
        }
        if coordinateY != nil{
            dictionary["coordinate_y"] = coordinateY
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isDestination != nil{
            dictionary["is_destination"] = isDestination
        }
        if isPhantom != nil{
            dictionary["is_phantom"] = isPhantom
        }
        if isTurnsVerbose != nil{
            dictionary["is_turns_verbose"] = isTurnsVerbose
        }
        if name != nil{
            dictionary["name"] = name
        }
        if text != nil{
            dictionary["text"] = text
        }
        if textBroadcast != nil{
            dictionary["text_broadcast"] = textBroadcast
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         beacon = aDecoder.decodeObject(forKey: "beacon") as? BeaconInfo
         coordinateX = aDecoder.decodeObject(forKey: "coordinate_x") as? Int
         coordinateY = aDecoder.decodeObject(forKey: "coordinate_y") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isDestination = aDecoder.decodeObject(forKey: "is_destination") as? Bool
         isPhantom = aDecoder.decodeObject(forKey: "is_phantom") as? Bool
         isTurnsVerbose = aDecoder.decodeObject(forKey: "is_turns_verbose") as? Bool
         name = aDecoder.decodeObject(forKey: "name") as? String
         text = aDecoder.decodeObject(forKey: "text") as? String
         textBroadcast = aDecoder.decodeObject(forKey: "text_broadcast") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if beacon != nil{
            aCoder.encode(beacon, forKey: "beacon")
        }
        if coordinateX != nil{
            aCoder.encode(coordinateX, forKey: "coordinate_x")
        }
        if coordinateY != nil{
            aCoder.encode(coordinateY, forKey: "coordinate_y")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isDestination != nil{
            aCoder.encode(isDestination, forKey: "is_destination")
        }
        if isPhantom != nil{
            aCoder.encode(isPhantom, forKey: "is_phantom")
        }
        if isTurnsVerbose != nil{
            aCoder.encode(isTurnsVerbose, forKey: "is_turns_verbose")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if text != nil{
            aCoder.encode(text, forKey: "text")
        }
        if textBroadcast != nil{
            aCoder.encode(textBroadcast, forKey: "text_broadcast")
        }

    }

}

class EdgeClass : NSObject, NSCoding{ // класс с маршрутом

    var start : Int!
    var stop : Int!
    var text : String!
    var weight : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        start = json["start"].intValue
        stop = json["stop"].intValue
        text = json["text"].stringValue
        weight = json["weight"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if start != nil{
            dictionary["start"] = start
        }
        if stop != nil{
            dictionary["stop"] = stop
        }
        if text != nil{
            dictionary["text"] = text
        }
        if weight != nil{
            dictionary["weight"] = weight
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         start = aDecoder.decodeObject(forKey: "start") as? Int
         stop = aDecoder.decodeObject(forKey: "stop") as? Int
         text = aDecoder.decodeObject(forKey: "text") as? String
         weight = aDecoder.decodeObject(forKey: "weight") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if start != nil{
            aCoder.encode(start, forKey: "start")
        }
        if stop != nil{
            aCoder.encode(stop, forKey: "stop")
        }
        if text != nil{
            aCoder.encode(text, forKey: "text")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "weight")
        }

    }

}
class BeaconInfo : NSObject, NSCoding{ // информация о метке

    var id : Int!
    var mac : String!
    var name : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        mac = json["mac"].stringValue
        name = json["name"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if mac != nil{
            dictionary["mac"] = mac
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         id = aDecoder.decodeObject(forKey: "id") as? Int
         mac = aDecoder.decodeObject(forKey: "mac") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if mac != nil{
            aCoder.encode(mac, forKey: "mac")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }

    }

}
