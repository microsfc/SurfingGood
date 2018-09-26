//
//  WeatherTableViewController.swift
//  SurfingGood
//
//  Created by liusean on 10/05/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit

class WeatherStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var rainPercent: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
}

class WeatherTableViewController: UITableViewController {
    var townName = "";
    var tableRowCount = 0;
    open var locationName: String = "頭城鎮"
    open var stationId: String = "F-D0047-001"
    open var dataType: String = "PoP6h"
    var rainingChanceDataArray: [NSMutableDictionary] = []
    @IBOutlet var rainingView: UITableView!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        self.getTaiwanWeatherData(_stationId: self.stationId)  // raining chance data
        self.title = self.locationName
        //        self.navigationItem.title = self.locationName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    You can use like this :
    //
    //    let urlString = "https://api.newsapi.aylien.com/api/v1/stories"
    //    let parameters = ["categories.confident": "true", "source.name" : "The New York Times", "cluster" : "false", "cluster.algorithm" : "lingo", "sort_by" : "published_at", "sort_direction" : "desc", "cursor" : "*", "per_page" : "10"]
    //    let headers = ["X-AYLIEN-NewsAPI-Application-ID": "App-ID-Here", "X-AYLIEN-NewsAPI-Application-Key": "App-Key-Here"]
    //
    //    var urlComponents = URLComponents(string: urlString)
    //
    //    var queryItems = [URLQueryItem]()
    //    for (key, value) in parameters {
    //    queryItems.append(URLQueryItem(name: key, value: value))
    //    }
    //
    //    urlComponents?.queryItems = queryItems
    //
    //    var request = URLRequest(url: (urlComponents?.url)!)
    //    request.httpMethod = "GET"
    //
    //    for (key, value) in headers {
    //    request.setValue(value, forHTTPHeaderField: key)
    //    }
    //
    //    let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
    //        print(response)
    //    }
    //    task.resume()
    
    func getTaiwanWeatherData(_stationId: String) -> Void {
        let urlString = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/\(_stationId)"
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name: "locationName", value: self.locationName))
        urlComponents.queryItems?.append(URLQueryItem(name: "elementName", value: dataType))
        guard let queryURL = urlComponents.url else { return }
        var request = URLRequest(url: queryURL)
        request.setValue("CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        self.fetchedDataByDataTask(from: request) { (Data) in
            print("data= \(Data)")
            if let record = Data["records"] as? [String: Any] {
                if let location = record["locations"] as? [Any] {
                    if let weatherSet = location[0] as? [String: Any] {
                        if let subWeatherSet = weatherSet["location"] as? [Any] {
                            if let targetData = subWeatherSet[0] as? [String: Any] {
                                print("hometown=\(targetData["locationName"])")
                                guard let townName = targetData["locationName"] as? String else {
                                    return
                                }
                                self.title = townName
                                if let weatherElementArray = targetData["weatherElement"] as? [Any] {
                                    if let weatherElement = weatherElementArray[0] as? [String: Any] {
                                        guard let description = weatherElement["description"] as? String else {
                                            return
                                        }
                                        //                                        self.title = townName + description
                                        self.navigationItem.title = townName + description
                                        if let dataRecord = weatherElement["time"] as? [Any] {
                                            self.tableRowCount = dataRecord.count
                                            for rainingElement in dataRecord {
                                                if let dataElement = rainingElement as? [String: Any] {
                                                    let dataJson: NSMutableDictionary = NSMutableDictionary()
                                                    dataJson.setValue(dataElement["startTime"], forKey: "startTime")
                                                    dataJson.setValue(dataElement["endTime"], forKey: "endTime")
                                                    if let percentData = dataElement["elementValue"] as? [Any] {
                                                        if let realData = percentData[0] as? [String: Any] {
                                                            dataJson.setValue(realData["value"], forKey: "百分比")
                                                        }
                                                    }
                                                    self.rainingChanceDataArray.append(dataJson)
                                                }
                                            }
                                            DispatchQueue.main.sync {
                                                self.rainingView.reloadData()
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
        //        guard  let url = URL(string:urlString) else {
        //            return false
        //        }
        //       let task = URLSession.shared.dataTask(with: request) {(data, response, error ) in
        //            if error != nil {
        //              print(error!.localizedDescription)
        //            }
        //            guard let resultData = data else { return }
        //            let json = try JSONSerialization.jsonObject(with: resultData) as? [String: Any]
        //            print("data %s", data)
        //        }
        //        task.resume();
        //        return true;
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
        return tableRowCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherStatusTableViewCell
        
        let dataJson = self.rainingChanceDataArray[indexPath.row]
        
        cell.startTime.text = "\(dataJson["startTime"] as! String)"
        cell.endTime.text = "\(dataJson["endTime"] as! String)"
        if let percent = Int(dataJson["百分比"] as! String) {
            if percent >= 0 && percent <= 20 {
                cell.weatherImage.image = UIImage(named: "sunny")
            }
            if percent > 20 && percent <= 50 {
                cell.weatherImage.image = UIImage(named: "cloud")
            }
            if percent > 50 && percent <= 100 {
                cell.weatherImage.image = UIImage(named: "rain")
            }
        }
        
        cell.rainPercent.text = dataJson["百分比"] as! String + "%"
        
        
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
