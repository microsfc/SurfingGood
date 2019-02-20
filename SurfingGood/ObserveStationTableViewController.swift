//
//  ObserveStationTableViewController.swift
//  MXviewToGo
//
//  Created by liusean on 16/01/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit

class ObserveStationCell: UITableViewCell {
    @IBOutlet weak var stationName: UILabel!
    
}

class ObserveStationTableViewController: UITableViewController {

    var stationName = ["頭城鎮", "金山區", "萬里區", "貢寮區", "恆春鎮", "東河鄉", "竹南鎮", "安平區", "旗津區"]
    var stationDataId = ["F-D0047-001", "F-D0047-069", "F-D0047-069", "F-D0047-069","F-D0047-033", "F-D0047-037","F-D0047-013", "F-D0047-077", "F-D0047-065"]
    
    
    
    var observeStationData: [NSMutableDictionary] = []
    
    override func viewDidLoad() {
        self.initObserveStationData()
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.observeStationData.count
    }

    func initObserveStationData() {
        for (_index, _) in stationName.enumerated() {
            let jsonObjectStation: NSMutableDictionary = NSMutableDictionary()
            let dataSet = NSMutableDictionary()
            dataSet.setValue(stationName[_index], forKey: "location")
            dataSet.setValue(stationDataId[_index], forKey: "stationId")
            jsonObjectStation.setValue(dataSet, forKey: stationName[_index])
            self.observeStationData.append(jsonObjectStation)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! ObserveStationCell
        let station = self.observeStationData[indexPath.row]
        let keys:[Any] = station.allKeys
        if let station = keys[0] as? String {
            cell.stationName.text = station
        }
        cell.accessoryType = .detailDisclosureButton
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let station = self.observeStationData[indexPath.row]
        let keys:[Any] = station.allKeys
        if let stationName = keys[0] as? String {
            if let stationData = station[stationName] as? NSMutableDictionary {
                let rainingViewController : WeatherTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "rainingViewCtrl") as! WeatherTableViewController
                rainingViewController.locationName = stationData["location"] as! String
                rainingViewController.stationId = stationData["stationId"] as! String
                self.navigationController?.pushViewController(rainingViewController, animated: true)
            }
            
            //            let vc : SeaTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "seaViewController") as! SeaTableViewController
//            vc.stationId = stationId
//            vc.stationName = stationName
        }
    
//        if (selectedEvent != nil) {
//            detailInfoPageViewController.currentEvent = selectedEvent;
//        }
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
