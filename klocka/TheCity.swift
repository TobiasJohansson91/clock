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
    
    /*
    var extraDay = 0
        let myTime = getTime()
    print(myTime)
    print(cityOffset)
        if cityOffset == 0 {
            return myTime
        }
        let min = Int(myTime.prefix(2))!
        var hours = Int(myTime.suffix(2))!
        let offsetMin = cityOffset%60
        let offsetHours = cityOffset/60
        var newMin = min + offsetMin
        if newMin >= 60{
            hours -= 1
            newMin -= 60
        }
        var newHours = hours + offsetHours
        if newHours >= 24{
            newHours -= 24
            extraDay = 1
        }
        let newTime = "\(newHours):\(newMin)"
        return newTime
 */
    }
}
