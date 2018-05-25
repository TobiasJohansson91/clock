//
//  ViewController.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-10.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseFavoriteCitiesDelegate, ApiRequestDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    var favoriteCities: [TheCity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatDate()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(formatDate), userInfo: nil, repeats: true)
        favoriteCities = UserDefaultHandler().getFromUserDefaults()
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(reloadTable), userInfo: nil, repeats: true)
        /*
        getChosenCities(cities: favoriteCities)
        for city in favoriteCities {
            print(city.cityName)
        }
        */
        //UserDefaultHandler().saveToUserDefaults(cities: [])
        //UserDefaultHandler().saveToUserdefaults(cityArray: [])
        //UserDefaultHandler().getCitiesFromUserDefaults()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CustomTableViewCell
        let city = favoriteCities[indexPath.row]
        cell.cityNameLabel.text = city.cityName
        cell.dateLabel.text = "10/5"
        cell.timeLabel.text = TheCity.calcTime(cityOffset: city.offset) 
        return cell
    }
    
    @objc func formatDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm EEE dd MMMM"
        timeLabel.text = formatter.string(from: Date())
    }
    
    func getChosenCities(cities: [[String:String]]) {
        print(cities)
        var lookupArray: [String] = []
        var newFavoriteArray: [TheCity] = []
        for city in cities {
            if let theCity = favoriteCities.first(where: {$0.cityName == city["city"]}) {
                newFavoriteArray.append(theCity)
            }else {
                lookupArray.append(city["city"]!)
            }
        }
        favoriteCities = newFavoriteArray
        UserDefaultHandler().saveToUserdefaults(cityArray: favoriteCities)
        tableView.reloadData()
        
        let apiRequster = ApiRequester()
        apiRequster.delegate = self
        for city in lookupArray {
            print("requster")
            apiRequster.getCityTimeZone(cityName: city)
        }
    }
    /*
    func getChosenCities(cities: [TheCity]) {
        print(cities)
        let apiRequster = ApiRequester()
        apiRequster.delegate = self
        for city in cities {
            print("requster")
            apiRequster.getCityTimeZone(cityName: city.cityName)
        }
    }
 */
    
    func getCity(city: TheCity) {
        if !favoriteCities.contains(where: {$0.cityName == city.cityName}) {
            favoriteCities.append(city)
        }
        tableView.reloadData()
        UserDefaultHandler().saveToUserdefaults(cityArray: favoriteCities)
    }
    
    func getAllCities(cities: [[String:String]]) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destController = segue.destination as! AllCitiesTableViewController
        destController.delegate = self
    }
    
    @objc func reloadTable(){
        tableView.reloadData()
    }
    
}

//TODO: Can select multiple cities - KLAR
//TODO: Can serch for cities    -   KLAR
//TODO: när du hämtar stad ska den kunna ta städer med mellanrum ex New York - KLAR
//TODO: Can search for countries, should i show "city, country"
//TODO: save favorites in userdefaults - KLART
//TODO: ska sökresultaten ha en tid eller kommer den först när staden blivit favoriter.
//TODO: ska sökresultatet sparas ner i userdefaults som en array med dictionarys så gör man bara api anrop en gång i veckan? Då behövs en egen tidräknare för varje stad
//TODO: Visare till klockan
//TODO: knappen för att hitta nya städer ska ha rundade kanter
//TODO: bakgrundsfärg eller bild
//TODO: Sätt ut ett datum till favoritstäderna


