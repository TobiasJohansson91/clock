//
//  TheCity.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-20.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

class TheCity: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cityName, forKey: "cityName")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(offset, forKey: "offset")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let cityName = aDecoder.decodeObject(forKey: "cityName") as! String
        let time = aDecoder.decodeObject(forKey: "time") as! String
        let offset = aDecoder.decodeInteger(forKey: "offset")
        self.init(cityName: cityName, time: time, offset: offset)
    }
    
    var cityName: String
    var time: String
    var offset: Int
   
    init(cityName: String, time: String, offset: Int) {
        self.cityName = cityName
        self.time = time
        self.offset = offset
    }
    
    static func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
   static func calcTime(cityOffset: Int) -> String {
    let offsetInSec = cityOffset * 60
    let formatter2 = DateFormatter()
    formatter2.dateFormat = "HH:mm"
    formatter2.timeZone = TimeZone(secondsFromGMT: offsetInSec)
    return formatter2.string(from: Date())
    }
    
    static func getDateByOffset(cityOffset: Int) -> String {
        let offsetInSec = cityOffset * 60
        let formatter3 = DateFormatter()
        formatter3.locale = Locale(identifier: Locale.current.identifier)
        formatter3.setLocalizedDateFormatFromTemplate("MMd")
        formatter3.timeZone = TimeZone(secondsFromGMT: offsetInSec)
        return formatter3.string(from: Date())
    }
}
