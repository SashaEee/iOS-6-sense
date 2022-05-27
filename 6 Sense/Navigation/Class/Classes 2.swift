//
//  Classes.swift
//  6 Sense
//
//  Created by Sasha on 2/18/22.
//

import Foundation
import SwiftyJSON

class BeaconClass : NSObject, NSCoding{ //хранение меток

    var id : Int!
    var location : Int!
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
        location = json["location"].intValue
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
        if location != nil{
            dictionary["location"] = location
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
         location = aDecoder.decodeObject(forKey: "location") as? Int
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
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if mac != nil{
            aCoder.encode(mac, forKey: "mac")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }

    }

}
