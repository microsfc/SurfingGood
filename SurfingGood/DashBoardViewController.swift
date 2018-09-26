//
//  CollectionViewControllertest.swift
//  SurfingGood
//
//  Created by liusean on 26/03/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DashBoardViewController: UICollectionViewController {

    @IBOutlet var surfLocationCollectionView: UICollectionView!
    
    @IBOutlet weak var surfLocationCollectionViewLayout: UICollectionViewFlowLayout!
    
    var surfSpotImage = ["wushi.jpg", "jinshan.jpg", "jinshan.jpg", "chunan.jpg", "JIALESHUEI.jpg", "Nawan.jpg", "TaiwanEasten.jpg"]
    var surfSpotName = ["烏石", "金山", "福隆", "竹南", "佳樂水", "南灣", "成功"]
    var observeStationData: NSMutableDictionary = NSMutableDictionary()
//        [NSMutableDictionary] = []
//    var observeStationData:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemWidth = (view.frame.size.width - 10) / 2
        surfLocationCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        let jsonObjectStation1: NSMutableDictionary = NSMutableDictionary()
//        let jsonObjectStation2: NSMutableDictionary = NSMutableDictionary()
//        let jsonObjectStation3: NSMutableDictionary = NSMutableDictionary()
//        let jsonObjectStation4: NSMutableDictionary = NSMutableDictionary()
//        let jsonObjectStation5: NSMutableDictionary = NSMutableDictionary()

        observeStationData.setValue("46708A", forKey: "烏石")
        observeStationData.setValue("46694A", forKey: "金山")
        observeStationData.setValue("1826", forKey: "福隆")
        observeStationData.setValue("WRA007", forKey: "竹南")
        observeStationData.setValue("46759A", forKey: "佳樂水")
        observeStationData.setValue("46759A", forKey: "南灣")
        observeStationData.setValue("46761F", forKey: "成功")
        
        
        
//        self.observeStationData.append(jsonObjectStation1)
//        self.observeStationData.append(location2)
//        self.observeStationData.append(location3)
//        self.observeStationData.append(location4)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "surfLocationViewCell", for: indexPath as IndexPath) as! surfLocationViewCollectionViewCell
        cell.surfLocationImageView.image = UIImage(named: surfSpotImage[indexPath.row])
        cell.surfSpotName.text = surfSpotName[indexPath.row]
        return cell	
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSurfSpot = self.surfSpotName[indexPath.row]
        let stationId: String = self.observeStationData[selectedSurfSpot] as! String
        
        
//        let stationId: String = station;
        let vc : SeaTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "seaViewController") as! SeaTableViewController
        vc.stationId = stationId
        vc.stationName = selectedSurfSpot
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
