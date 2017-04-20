//
//  ATMTableViewController.swift
//  PrivatBankAPI
//
//  Created by Andrij Trubchanin on 4/20/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit

class ATMTableViewController: UITableViewController {
    
    private var ATMList: [String] = []
    
    private func fetchATM(in city: String) {
        ATMList = ["FIRST"]
        
        let searchCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard searchCity != nil else {
            ATMList.append("INCORRECT CITY NAME")
            return
        }
        
        let apiPath = "https://api.privatbank.ua/p24api/infrastructure?json&atm&address=&city=" + searchCity!
        let url = URL(string: apiPath)
        
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, responce, error) in
            if error != nil {
                self?.ATMList.append("ERROR")
            } else {
                if let content = data {
                    do {
                        let jsonContent = try JSONSerialization.jsonObject(with: content, options: .mutableContainers)
                        
                        if let jsonDict = jsonContent as? [String: Any] {
                            if let devices = jsonDict["devices"] as? [[String: Any]] {
                                for device in devices {
                                    if let atm = device["fullAddressRu"] as? String {
                                        self?.ATMList.append(atm)
                                    }
                                }
                            } else {
                                self?.ATMList.append("NO DEVICES")
                            }
                        } else {
                            self?.ATMList.append("CANT PARSE DATA")
                        }
                    }
                    catch {
                        self?.ATMList.append("ERROR \(error.localizedDescription)")
                    }
                } else {
                    self?.ATMList.append("NO DATA")
                }
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchATM(in: "Кременчук")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ATMList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ATMCell", for: indexPath)

        cell.textLabel?.text = ATMList[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
