//
//  UserDefaultHandler.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-11.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

class UserDefaultHandler {
    let FAVORITE_TIMEZONE_KEY = "favoriteTimezone"
    let userDefault = UserDefaults.standard
    
    func saveToUserdefaults(cityArray: [TheCity]){
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: cityArray)
        userDefault.set(encodeData, forKey: FAVORITE_TIMEZONE_KEY)
    }
    
    func getFromUserDefaults() -> [TheCity]{
        let data = userDefault.data(forKey: FAVORITE_TIMEZONE_KEY)
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as! [TheCity]
        }
        return []
    }
    
    func saveToUserDefaults(cities: [[String:String]]){
        userDefault.set(cities, forKey: "arrayDict")
    }
    
    func getCitiesFromUserDefaults() -> [[String:String]]{
        var array = userDefault.array(forKey: "arrayDict")
        if let array = array {
            return array as! [[String:String]]
        }
        return []
    }
}
