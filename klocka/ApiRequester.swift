//
//  ApiRequester.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-10.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

protocol ApiRequestDelegate {
    func getAllCities(cities: [[String:String]])
    func getCity(city: TheCity)
}

class ApiRequester {
    private let API_KEY =  "h83JFTPzb7EWc9SK4zCzWkDKMu6Y2t" //"pv8AiDUeCj7L8uLeups5ctEFeFqv2n" //"4K9p4u7wqPJmPQFLewzLgLUh2rVzvF"
    var delegate: ApiRequestDelegate?
    var allCities: [[String:String]] = []
    //"https://www.amdoren.com/api/timezone.php?api_key=4K9p4u7wqPJmPQFLewzLgLUh2rVzvF&loc=Stockholm"
    
    
    func getAllCities() {
        let url = URL(string: "https://www.amdoren.com/api/locations.php?api_key=h83JFTPzb7EWc9SK4zCzWkDKMu6Y2t")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("some error when requesting data")
            } else {
                if let data = data {
                    do{
                        let decodedData = try JSONDecoder().decode(Cities.self, from: data)
                        for city in decodedData.locations {
                            let dictionary = ["country": city.country, "city": city.city]
                            self.allCities.append(dictionary)
                        }
                        DispatchQueue.main.async {
                            self.delegate?.getAllCities(cities: self.allCities)
                        }
                    }catch let jsonError{
                        print(jsonError)
                    }
                } else {
                    print("Data was nil")
                }
            }
        }.resume()
    }
    
    func getCityTimeZone(cityName: String){
        let stringUrl = "https://www.amdoren.com/api/timezone.php?api_key=h83JFTPzb7EWc9SK4zCzWkDKMu6Y2t&loc=" + replaceBlankSpace(string: cityName)
        print(replaceBlankSpace(string: cityName))
        guard let url = URL(string: stringUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Some error when fetching city")
            } else {
                if let data = data {
                    do {
                        let parsedData = try JSONDecoder().decode(OneCity.self, from: data)
                        if parsedData.error == 0 {
                            let city = TheCity(cityName: cityName, time: parsedData.time, offset: parsedData.offset)
                            DispatchQueue.main.async {
                                self.delegate?.getCity(city: city)
                            }
                        }
                        print("Error nr", parsedData.error)
                    } catch let jsonError {
                       print("error when parsing json")
                    }
                } else {
                    print("city data was empty")
                }
            }
        }.resume()
    }
    func replaceBlankSpace(string: String) -> String{
     return string.replacingOccurrences(of: " ", with: "+")
    }
}

struct Cities: Decodable {
    let locations: [City]
}

struct City: Decodable {
    let country: String
    let state: String?
    let city: String
}

struct OneCity: Decodable {
    let error: Int
    let time: String
    let offset: Int
}
