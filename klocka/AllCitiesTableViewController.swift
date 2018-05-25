//
//  AllCitiesTableViewController.swift
//  klocka
//
//  Created by lösen är 0000 on 2018-05-10.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit

protocol ChooseFavoriteCitiesDelegate {
    func getChosenCities(cities: [[String:String]])
}

class AllCitiesTableViewController: UITableViewController, ApiRequestDelegate, UISearchBarDelegate {
    
    let apiRequester = ApiRequester()
    var dataArray: [[String:String]] = []
    var tableSourceArray: [[String:String]] = []
    var selectedCities: [[String:String]] = []
    var delegate: ChooseFavoriteCitiesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        dataArray = UserDefaultHandler().getCitiesFromUserDefaults()
        if dataArray.count == 0 {
            apiRequester.delegate = self
            apiRequester.getAllCities()
        }else {
            tableSourceArray = dataArray
        }
        tableView.allowsMultipleSelection = true
        
        favoriteCitiesToSelectedCities()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
        print(tableView.indexPathsForSelectedRows)
        print("is it working?")
        guard let indexPaths = tableView.indexPathsForSelectedRows else{return}
        var array: [[String:String]] = []
        for path in indexPaths {
            array.append(tableSourceArray[path.row])
        }
        //print(array)
 */
        delegate?.getChosenCities(cities: selectedCities)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableSourceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier2", for: indexPath) as! SecondCustomTableViewCell
        let cityName = tableSourceArray[indexPath.row]["city"]!
        cell.citiNameLabel.text = cityName
        preSelectRows(cityName: cityName, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCities.append(tableSourceArray[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedCities = selectedCities.filter({$0["city"] != tableSourceArray[indexPath.row]["city"]})
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getAllCities(cities: [[String:String]]) {
        UserDefaultHandler().saveToUserDefaults(cities: cities)
        dataArray = cities
        tableSourceArray = dataArray
        tableView.reloadData()
        print(dataArray)
    }
    
    func getCity(city: TheCity) {
    }
    
    func preSelectRows(cityName: String, indexPath: IndexPath){
        if selectedCities.contains(where: {$0["city"] == cityName}){
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        }
        /*
        let favorites = UserDefaultHandler().getFromUserDefaults()
        print(favorites)
        for city in favorites {
            let index = tableSourceArray.index(where: {
                return $0["city"] == city.cityName})
            let indexPath = IndexPath(row: index!, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        }
 */
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Stad"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableSourceArray = dataArray
            tableView.reloadData()
        } else {
            let text = searchText.lowercased()
            tableSourceArray = dataArray.filter({($0["city"]?.lowercased().contains(text))!})
            tableView.reloadData()
        }
    }
    
    func favoriteCitiesToSelectedCities(){
        let favorites = UserDefaultHandler().getFromUserDefaults()
        for city in favorites{
            let element = dataArray.first(where: {$0["city"] == city.cityName})
            if let element = element{
                selectedCities.append(element)
            }
        }
    }

}
