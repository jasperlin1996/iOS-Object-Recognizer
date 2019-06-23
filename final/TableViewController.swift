//
//  TableViewController.swift
//  final
//
//  Created by Jasper Lin on 2019/6/21.
//  Copyright © 2019 jasperlin1996. All rights reserved.
//

import UIKit
import os.log
class TableViewController: UITableViewController{
    
    static var historyData: Array<ClassifiedData> = []
    var dataSource: UITableViewDataSource?
    static func readDataFromUserDefault(){
        let userDefault = UserDefaults.standard
        historyData = []
        if let classifiedDataDicts = userDefault.array(forKey: "data") as? [[String: Any]] {
            for data in classifiedDataDicts {
                let tmp = ClassifiedData(label: data["label"] as? String ?? "", imageName: data["imageName"] as? String ?? "")
                historyData.append(tmp)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Read data from UserDefaults, including label and imageName
        TableViewController.readDataFromUserDefault()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // print(TableViewController.historyData.count)
        return TableViewController.historyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyRecord", for: indexPath) as! HistoryTableViewCell
        
        // Configure the cell
        let singleHistory = TableViewController.historyData[indexPath.row]
        cell.historylabel?.text = singleHistory.label
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageUrl = documentDirectory.appendingPathComponent(singleHistory.imageName).appendingPathExtension("png")
        cell.historyImage?.image = UIImage(contentsOfFile: imageUrl.path)
        print(imageUrl.path)
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
