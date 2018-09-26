//
//  TideStationCollectionViewController.swift
//  SurfingGood
//
//  Created by liusean on 31/05/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TideStationCollectionViewController: UICollectionViewController {

    var surfSpotImage = ["wushi.jpg", "jinshan.jpg", "jinshan.jpg", "chunan.jpg", "JIALESHUEI.jpg", "Nawan.jpg", "TaiwanEasten"]
    var surfSpotName = ["烏石", "金山", "福隆", "竹南", "佳樂水", "南灣", "成功"]
    var observeStationData: NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet var surfTidalLocationCollectionView: UICollectionView!
    @IBOutlet weak var surfLocationTidalViewLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let itemWidth = (view.frame.size.width - 10) / 2
        surfLocationTidalViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        observeStationData.setValue("漁港烏石", forKey: "烏石")
        observeStationData.setValue("海水浴場翡翠灣", forKey: "金山")
        observeStationData.setValue("海水浴場福隆", forKey: "福隆")
        observeStationData.setValue("苗栗縣漁港龍鳳", forKey: "竹南")
        observeStationData.setValue("屏東縣漁港後壁湖", forKey: "佳樂水")
        observeStationData.setValue("海水浴場南灣", forKey: "南灣")
        observeStationData.setValue("臺東縣成功鎮", forKey: "成功")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "surfTideCollectionViewCell", for: indexPath as IndexPath) as! surfStationTidalCollectionViewCell
        
        cell.surfLocationLabel.text = self.surfSpotName[indexPath.row]
        cell.surfLocationTidalImageView.image = UIImage(named: surfSpotImage[indexPath.row])
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSurfSpot = self.surfSpotName[indexPath.row]
        let stationId: String = self.observeStationData[selectedSurfSpot] as! String
        
        
        //        let stationId: String = station;
        let vc : TidalTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "tidalTableViewController") as! TidalTableViewController
        vc.locationName = stationId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
