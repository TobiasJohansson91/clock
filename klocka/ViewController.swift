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
    @IBOutlet weak var handContainer: UIView!
    @IBOutlet weak var hourHand: UIImageView!
    @IBOutlet weak var minuteHand: UIImageView!
    var handsWidth: CGFloat!
    var minHandHeight: CGFloat!
    var hourHandHeight: CGFloat!
    var favoriteCities: [TheCity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCities = UserDefaultHandler().getFromUserDefaults()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm EEE dd MMMM"
        timeLabel.text = formatter.string(from: Date())
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(reloadTable), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handsWidth = handContainer.frame.width * 0.064
        hourHandHeight = handContainer.frame.height * 0.594
        minHandHeight = handContainer.frame.height * 0.817
        let middleX = handContainer.frame.width / 2
        let middleY = handContainer.frame.height / 2
        
        hourHand.frame = CGRect(x: middleX - (handsWidth/2), y: middleY - hourHandHeight/2, width: handsWidth, height: hourHandHeight)
        minuteHand.frame = CGRect(x: middleX - (handsWidth/2), y: middleY - minHandHeight/2, width: handsWidth, height: minHandHeight)
        
        setAnalogClock()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(formatDate), userInfo: nil, repeats: true)
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
        cell.dateLabel.text = TheCity.getDateByOffset(cityOffset: city.offset) 
        cell.timeLabel.text = TheCity.calcTime(cityOffset: city.offset) 
        return cell
    }
    
    @objc func formatDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm EEE dd MMMM"
        timeLabel.text = formatter.string(from: Date())
        tick()
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
    
    func setAnalogClock() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: Date())
        var hour = CGFloat(Int(String(time.prefix(2)))!)
        let min = CGFloat(Int(String(time.suffix(2)))!)
        if hour > 12 {hour -= 12 }
        let moveHour = CGFloat.pi/360 * hour * 60
        let moveMin = CGFloat.pi/30 * min
        print(hour, min)
        self.hourHand.transform = self.hourHand.transform.rotated(by: moveHour)
        self.minuteHand.transform = self.minuteHand.transform.rotated(by: moveMin)
    }
    
    func tick() {
        let moveMin = CGFloat.pi/30
        let moveHour = CGFloat.pi/360
        
        UIView.animate(withDuration: 1, animations: {
            self.minuteHand.transform = self.minuteHand.transform.rotated(by: moveMin)
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.hourHand.transform = self.hourHand.transform.rotated(by: moveHour)
        })
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


