//
//  ViewController.swift
//  HandleCSVFile
//
//  Created by Artur Daylidonis on 18/5/20.
//  Copyright © 2020 Artur Daylidonis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let fileName = "ProductsData"
    let fileExtension = "csv"
    var cells: [[String]]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DataCell", bundle: nil), forCellReuseIdentifier: "DataCell")
        
        self.title = "CSV Data"

        if let data = handleCSVFile(name: fileName, extension: fileExtension) {
            cells = data
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfCells = cells?.count {
            return numberOfCells
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        
        if let code = cells?[indexPath.row][0] { cell.detailLabel.text = code }
        if let name = cells?[indexPath.row][1], let model = cells?[indexPath.row][2] { cell.titleLabel.text = "\(name) \(model)" }
        if let priceString = cells?[indexPath.row][3], let price = Int(priceString) { cell.valueLabel.text = self.priceToString(price)[2] }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func handleCSVFile(name: String, extension: String) -> [[String]]? {
        if let documents = Bundle.main.urls(forResourcesWithExtension: fileExtension, subdirectory: nil) {
            if let data = try? String(contentsOf: documents[0]) {
                var result: [[String]] = []
                let rows = data.components(separatedBy: "\r\n")
                for row in rows {
                    let columns = row.components(separatedBy: ",")
                    var cells: [String] = []
                    
                    for item in columns {
                        let cell = item.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                        if cell != "" {
                            cells.append(cell)
                        }
                    }
                    
                    // Only append the array if it's not empty
                    if cells != [] {
                        result.append(cells)
                        print(cells)
                    }
                }
                
                // Double check that the array doesn't contain any empty entries
                for i in 0 ..< result.count {
                    if result[i] == [] {
                        result.remove(at: i)
                    }
                }
                
                print(result.last!)
                return result
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}

extension UIViewController {
    func priceToString(_ priceInCents: Int, currency: String = "$") -> [String] {
        var arrayOfValues = [String]()
        var totalString = ""
        var priceWithoutGSTString = ""
        var gstString = ""
        
        let gstTemp = priceInCents * 100 / 110 * 10
        let gstDouble: Double = (ceil((Double(gstTemp) / 100)) / 100).truncate(places: 2)
        let totalPriceDouble: Double = (Double(priceInCents) / 100).truncate(places: 2)
        let priceWithoutGSTDouble: Double = totalPriceDouble - gstDouble
        
        print("\(priceWithoutGSTDouble), \(gstDouble), \(totalPriceDouble)")
        
        // Price
        if ceil(priceWithoutGSTDouble) == priceWithoutGSTDouble {
            priceWithoutGSTString = "\(Int(priceWithoutGSTDouble)).00"
        } else if ceil(priceWithoutGSTDouble * 10) == priceWithoutGSTDouble * 10 {
            priceWithoutGSTString = "\(priceWithoutGSTDouble.truncate(places: 1))0"
        } else {
            priceWithoutGSTString = "\((priceWithoutGSTDouble + 0.005).truncate(places: 2))"
        }
        
        // GST
        if ceil(gstDouble) == gstDouble {
            gstString = "\(Int(gstDouble)).00"
        } else if ceil(gstDouble * 10) == gstDouble * 10 {
            gstString = "\(gstDouble.truncate(places: 1))0"
        } else {
            gstString = "\(gstDouble.truncate(places: 2))"
        }
        
        // Total
        if ceil(totalPriceDouble) == totalPriceDouble {
            totalString = "\(Int(totalPriceDouble)).00"
        } else if ceil(totalPriceDouble * 10) == totalPriceDouble * 10 {
            totalString = "\(totalPriceDouble.truncate(places: 1))0"
        } else {
            totalString = "\(totalPriceDouble.truncate(places: 2))"
        }

        // Custom currency display rules
        switch currency {
        case "₽":
            arrayOfValues.append(priceWithoutGSTString + " (\(currency)")
            arrayOfValues.append(gstString + " (\(currency)")
            arrayOfValues.append(totalString + " (\(currency)")
        default:
            arrayOfValues.append(currency + priceWithoutGSTString)
            arrayOfValues.append(currency + gstString)
            arrayOfValues.append(currency + totalString)
        }
        
        return arrayOfValues
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
