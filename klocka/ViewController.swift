//
//  ViewController.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-10.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        formatDate()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(formatDate), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CustomTableViewCell
        cell.cityNameLabel.text = "Falkenberg"
        cell.dateLabel.text = "10/5"
        cell.timeLabel.text = "12:50"
        return cell
    }
    
    @objc func formatDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm EEE dd MMMM"
        timeLabel.text = formatter.string(from: Date())
    }
    
}

//TODO: Can select multiple cities
//TODO: Can serch for cities
//TODO: Can search for countries, should i show "city, country"
//TODO: save favorites in userdefaults
//TODO: ska sökresultaten ha en tid eller kommer den först när staden blivit favoriter.
//TODO: ska sökresultatet sparas ner i userdefaults som en array med dictionarys så gör man bara api anrop en gång i veckan? Då behövs en egen tidräknare för varje stad
//TODO: Visare till klockan
//TODO: knappen för att hitta nya städer ska ha rundade kanter
//TODO: bakgrundsfärg eller bild


