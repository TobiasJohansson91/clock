//
//  ApiRequester.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-10.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

protocol ApiRequestDelegate {
    func getAllCities(cities: Cities)
    //func getCitie()
}

class ApiRequester {
    private let API_KEY = "4K9p4u7wqPJmPQFLewzLgLUh2rVzvF"
    var delegate: ApiRequestDelegate?
    //"https://www.amdoren.com/api/timezone.php?api_key=4K9p4u7wqPJmPQFLewzLgLUh2rVzvF&loc=Stockholm"
    
    
    func getAllCities() {
        let url = URL(string: "https://www.amdoren.com/api/locations.php?api_key=4K9p4u7wqPJmPQFLewzLgLUh2rVzvF")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("some error when requesting data")
            } else {
                if let data = data {
                    do{
                        let decodedData = try JSONDecoder().decode(Cities.self, from: data)
                        DispatchQueue.main.async {
                            self.delegate?.getAllCities(cities: decodedData)
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
}

struct Cities: Decodable {
    let locations: [City]
}

struct City: Decodable {
    let country: String
    let state: String?
    let city: String
}
