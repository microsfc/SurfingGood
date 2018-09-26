//
//  TidalTableViewController.swift
//  SurfingGood
//
//  Created by liusean on 29/05/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit

class TidalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tidalTime: UILabel!
    @IBOutlet weak var tidalStatus: UILabel!
    @IBOutlet weak var tideImage: UIImageView!
}

class TidalTableViewController: UITableViewController {
    
    var townName = "";
    var tableRowCount = 0;
    open var locationName: String = "漁港烏石"
    open var dataType: String = "1日潮汐"
    var tideStatusDataArray: [NSMutableDictionary] = []
    var sortedTideStatusArray: [NSMutableDictionary] = []
    var sortedTimeArray: [NSMutableDictionary] = []
    
    @IBOutlet var tideStatusTableView: UITableView!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        self.getTaiwanTidalStatus(_dataId: "F-A0021-001") // 潮汐
        self.title = "\(self.locationName) 潮汐"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTaiwanTidalStatus(_dataId: String) -> Void {
        let urlString = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/\(_dataId)"
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name:  "locationName", value: self.locationName))
        urlComponents.queryItems?.append(URLQueryItem(name:  "elementName", value: self.dataType))
        guard let queryURL = urlComponents.url else { return }
        var request = URLRequest(url: queryURL)
        request.setValue("CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        self.fetchedDataByDataTask(from: request) { (Data) in
            print("data= \(Data)")
            if let record = Data["records"] as? [String: Any] {
                if let location = record["location"] as? [Any] {
                    if location.count > 0 {
                        if let weatherSet = location[0] as? [String: Any] {
                            guard let townName = weatherSet["locationName"] as? String else {
                                return
                            }
                            self.title = townName
                            if let subWeatherSet = weatherSet["validTime"] as? [Any] {
//                                self.sortedTimeArray = subWeatherSet.sorted{ (one, two) -> Bool in
//                                    if case let one as? [String: Any] {
//                                        if let two as? [String: Any] {
//                                            return one["startTime"] > two["startTime"]
//                                        }
//                                    }
//                                }
//                                let index = subWeatherSet.count - 1
//                                for element in subWeatherSet {
                                for (index, element) in subWeatherSet.enumerated().reversed() {
                                    print("index\(index)")
                                    if let targetData = element as? [String: Any] {
                                        if let tideStatusArray = targetData["weatherElement"] as? [Any] {
                                            if let tideElement = tideStatusArray[0] as? [String: Any] {
                                                guard let description = tideElement["elementName"] as? String else {
                                                    return
                                                }
                                                //                                        self.title = townName + description
                                                self.navigationItem.title = townName + description
                                                if let dataRecord = tideElement["time"] as? [Any] {
                                                    self.tableRowCount = dataRecord.count
                                                    for tideStatusElement in dataRecord {
                                                        if let dataElement = tideStatusElement as? [String: Any] {
                                                            let dataJson: NSMutableDictionary = NSMutableDictionary()
                                                            dataJson.setValue(dataElement["dataTime"], forKey: "tidalTime")
                                                            if let percentData = dataElement["parameter"] as? [Any] {
                                                                if let realData = percentData[0] as? [String: Any] {
                                                                    dataJson.setValue(realData["parameterValue"], forKey: "tidalStatus")
                                                                }
                                                            }
                                                            self.tideStatusDataArray.append(dataJson)
                                                        }
                                                    }
                                                    self.sortedTideStatusArray = self.tideStatusDataArray.sorted{ one , two in
                                                        return (one["tidalTime"] as! String) < (two["tidalTime"] as! String) }
                                                    DispatchQueue.main.sync {
                                                        self.tideStatusTableView.reloadData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping ([String: Any]) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    completion(json!)
                }
                catch {
                    print("transfer to json error = \(error)")
                }
                
            }
        }
        task.resume()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.sortedTideStatusArray.count > 0 {
            return self.sortedTideStatusArray.count
        } else {
            return self.tideStatusDataArray.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TidalCell", for: indexPath) as! TidalTableViewCell
        
        var dataJson:NSMutableDictionary
        
        if self.sortedTideStatusArray.count > 0 {
            dataJson = self.sortedTideStatusArray[indexPath.row]
        } else {
            dataJson = self.tideStatusDataArray[indexPath.row]
        }
        cell.tidalTime.text = "潮汐時間： \(dataJson["tidalTime"] as! String)"
        if let tideStatus = dataJson["tidalStatus"] as? String {
            if tideStatus == "滿潮" {
                cell.tideImage.image = UIImage(named: "highTide")
            } else if tideStatus == "乾潮" {
                cell.tideImage.image = UIImage(named: "lowTide")
            }
            cell.tidalStatus.text = "潮汐："
        } else {
            cell.tidalStatus.text = "潮汐： \(dataJson["tidalStatus"] as! String)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
    
}
