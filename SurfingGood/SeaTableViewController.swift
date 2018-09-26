//
//  SeaTableViewController.swift
//  MXviewToGo
//
//  Created by liusean on 08/01/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
//import SwiftHTTP

struct seaStatus {
    let seaLocation: String
    let seaTemperture: Int16
}

class SeaStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var seaStatus: UILabel!
    @IBOutlet weak var waveStatus: UILabel!	
    @IBOutlet weak var ObserveTime: UILabel!
    @IBOutlet weak var windDirection: UIImageView!
}

class SeaTableViewController: UITableViewController {

    var seaStatusArray: [NSMutableDictionary] = []
    var sortedSeaStatusArray: [NSMutableDictionary] = []
    open var stationId: String = "";
    open var stationName: String = "";
    var dateString = "";
    
    @IBOutlet var seaTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.title = self.stationName
        self.seaTableView.rowHeight = 200
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
//            let opt = try HTTP.GET("http://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0018-001", parameters: ["stationId": self.stationId, "limit": "100"], headers: ["authorization": "CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD"])
//            opt.start { response in
//                if response.error != nil {
//                    print("error= \(response.error)")
//                }
//                print("response: \(response.data)")
//                var json: Any?
            let urlString = "http://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0018-001"
            var urlComponents = URLComponents(string: urlString)!
            urlComponents.queryItems = []
            urlComponents.queryItems?.append(URLQueryItem(name:  "stationId", value: self.stationId))
            urlComponents.queryItems?.append(URLQueryItem(name:  "limit", value: "100"))
            guard let queryURL = urlComponents.url else { return }
            var request = URLRequest(url: queryURL)
            request.setValue("CWB-6374C03F-A414-4F8C-99C8-5919A68EA0AD", forHTTPHeaderField: "authorization")
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            self.fetchedDataByDataTask(from: request) { (Data) in
                
                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
                    let recordJSON = Data["records"] as? [String: Any]
                    let location = recordJSON!["location"] as? [[String: Any]]
                    for object in location! {
                        if let stationId = object["stationId"] as? Any {
                            print("stationId=\(stationId)")
                        }
                        if let object2 = object["time"] as? [[String: Any]] {
                            for object3 in object2 {
                                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                                print("object3 time=\(object3["obsTime"])")
                                if let time = object3["obsTime"] as? String {
                                    jsonObject.setValue(time, forKey: "observeTime")
                                }
                                
                                guard let weatherObject = object3["weatherElement"] as? [[String: Any]] else {
                                    continue
                                }
                                var seaStatusString = ""
                                var waveStatusString = ""
                                var windDirection = ""
                                
                                for object4 in weatherObject {
                                    guard let elementValue = object4["elementValue"] as? String else {
                                        continue
                                    }
//                                    if jsonObject["陣風"] != nil {
//                                        continue
//                                    }
//                                    if jsonObject["平均風"] != nil {
//                                        continue
//                                    }
//                                    if jsonObject["風向"] != nil {
//                                        continue
//                                    }
                                    let elementName = object4["elementName"] as! String
                                    print("elementName=\(elementName)")
                                    switch elementName {
                                    case "陣風", "平均風", "風向", "氣溫":
                                        var value = 0.0
                                        switch elementName {
                                        case "陣風", "平均風", "氣溫":
                                             value = Double(elementValue)!
                                             value = value / 10
                                        default:
                                            value = Double(elementValue)!
                                        }
                                        var fullValue = ""
                                        switch elementName {
                                        case "陣風", "平均風":
                                            fullValue = String(describing: value) + "公尺/秒"
                                        case "氣溫":
                                            fullValue = String(describing: value) + "度C"
                                        case "風向":
                                            switch(value) {
                                                case 0...10:
                                                 fullValue = "北風"
                                                case 11...60:
                                                 fullValue = "東北風"
                                                case 61...90:
                                                fullValue = "東風"
                                                case 91...179:
                                                 fullValue = "東南風"
                                                case 180:
                                                 fullValue = "南風"
                                                case 181...269:
                                                 fullValue = "西南風"
                                                case 270:
                                                 fullValue = "西風"
                                                case 271...348:
                                                 fullValue = "西北風"
                                            default:
                                                 fullValue = "無風"
                                            }
                                            print("degree=%d\n" ,value)
                                            windDirection = fullValue
                                        default:
                                            fullValue = String(describing: value)
                                        }
                                        if (elementName == "陣風") {
                                            seaStatusString = seaStatusString + "\n"
                                        }
                                        seaStatusString = seaStatusString + elementName
                                        seaStatusString = seaStatusString + fullValue + " "
                                    case "海溫", "浪高", "週期", "波向":
                                        var value = 0.0
                                        switch elementName {
                                        case "海溫", "週期":
                                            value = Double(elementValue)!
                                            value = value / 10
                                            surfingDataService.saveSeaStatus(seaTemperature: value)
                                        case "浪高":
                                            value = Double(elementValue)!
                                            value = value / 100
                                        default:
                                            value = Double(elementValue)!
                                        }
                                        waveStatusString = waveStatusString + elementName
                                        var fullValue = ""
                                        switch elementName {
                                            case "海溫":
                                            fullValue = String(describing: value) + "度C"
                                            case "浪高":
                                            fullValue = String(describing: value) + "公尺"
                                            case "週期":
                                            fullValue = String(describing: value) + "秒"
                                            case "波向":
                                                switch(value) {
                                                case 0:
                                                    fullValue = "北"
                                                case 1...89:
                                                    fullValue = "東北"
                                                case 90:
                                                    fullValue = "東"
                                                case 91...179:
                                                    fullValue = "東南"
                                                case 180:
                                                    fullValue = "南"
                                                case 181...269:
                                                    fullValue = "西南"
                                                case 270:
                                                    fullValue = "西"
                                                case 271...348:
                                                    fullValue = "西北"
                                                default:
                                                    fullValue = "無"
                                                }
                                            default:
                                            fullValue = String(describing: value)
                                        }
                                        waveStatusString = waveStatusString + fullValue + " "
                                    default:
                                            print("not match any elementName")
                                    }
                                }
                                jsonObject.setValue(seaStatusString, forKey: "seaStatus")
                                jsonObject.setValue(waveStatusString, forKey: "waveStatus")
                                jsonObject.setValue(windDirection, forKey: "windDirection")
                                self.seaStatusArray.append(jsonObject)
                            }
                        }
                    }
                             
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yy/MM/dd a"
                    self.sortedSeaStatusArray = self.seaStatusArray.sorted{ one, two in
                        return one["observeTime"] as! String > two["observeTime"] as! String }
                        //return dateFormatter.date(from: one["observeTime"] as! String )! > dateFormatter.date(from: two["observeTime"] as! String )! }
                    
                    
//                    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "observeTime", ascending: true)
//                    self.seaStatusArray = self.seaStatusArray.sortedArrayUsingDescriptors([descriptor])
                    
                    //use:
                    DispatchQueue.main.async {
                        self.seaTableView.reloadData()
                        let sea:[SeaStatus] = surfingDataService.fetchSeaStaus()
                        for i in sea {
                            print("sea temperature \(i.seaTemperature)")
                        }
                    }
//                    for (key, value) in recordJSON? {
//                        // access all key / value pairs in dictionary
//                        print("key1= \(key) value1= \(value)")
//                        if let nestedDictionary = recordJSON![key] as? [String: Any] {
//                            // access nested dictionary values by key
//                             for (key, value) in recordJSON! {
//                                print("key2= \(key) value2= \(value)")
//                            }
//                        }
//                    }
//                    print("all json=\(json)")
//                    print("records json=\(json?["records"])")
//                    print("station id=\(json?.first?["location"]["stationId"])")
                } catch {
                    print(error)
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if self.sortedSeaStatusArray.count > 0 {
            return self.sortedSeaStatusArray.count
        }else {
            return self.seaStatusArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seaStatusLabelCell", for: indexPath) as! SeaStatusTableViewCell
        var sea: NSMutableDictionary;
        if self.sortedSeaStatusArray.count > 0 {
            sea = self.sortedSeaStatusArray[indexPath.row]
        }else {
            sea = self.seaStatusArray[indexPath.row]
        }
       
        let seaStatusString = sea["seaStatus"] as! String
        let waveStatusString = sea["waveStatus"] as! String
        let obsTime = sea["observeTime"] as! String
        let windDirection = sea["windDirection"] as! String
        
        cell.seaStatus.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.seaStatus.numberOfLines = 2
        cell.seaStatus?.text = seaStatusString
        cell.ObserveTime?.text = obsTime
        cell.waveStatus?.text = waveStatusString
        switch(windDirection) {
        case "北風":
            cell.windDirection?.image = UIImage(named: "N")
        case "東北風":
            cell.windDirection?.image = UIImage(named: "NE")
        case "東風":
            cell.windDirection?.image = UIImage(named: "E")
        case "東南風":
            cell.windDirection?.image = UIImage(named: "SE")
        case "南風":
            cell.windDirection?.image = UIImage(named: "S")
        case "西南風":
            cell.windDirection?.image = UIImage(named: "SW")
        case "西風":
            cell.windDirection?.image = UIImage(named: "W")
        case "西北風":
            cell.windDirection?.image = UIImage(named: "NW")
        default:
            cell.windDirection?.image = UIImage(named: "")
        }
        
        return cell
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
