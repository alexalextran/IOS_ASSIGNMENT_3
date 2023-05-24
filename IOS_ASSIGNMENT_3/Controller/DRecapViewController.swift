//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit

extension NSString {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}


class DRecapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moodE:String?
    var textE:String?
    var formmattedDate:String?
    
    struct Entry: Codable{
        var mood:String
        var text:String
    }
    var entries = [String: [Entry]]()
    let KEY_DAILY_ENTRIES = "dailyEntries"
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
 
    
    @IBOutlet weak var entriesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        entries = readEntries()
        writeEntry();
        print(formmattedDate)
        print(entries)
            
     
        self.entriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

           

              entriesTable.delegate = self
              entriesTable.dataSource = self
             
          
    }
    
    
    
    func writeEntry() {
        let userDefaults = UserDefaults.standard
        let newEntry = Entry(mood: moodE!, text: textE!)

        if entries[formmattedDate!] != nil {
            entries[formmattedDate!]!.append(newEntry)
        } else {
            entries[formmattedDate!] = [newEntry]
        }

        userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
    }

    

    //retrieve highscores from the database
    func readEntries()-> [String: [Entry]]{
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data{ if let array = try? PropertyListDecoder().decode([String: [Entry]].self,from: savedArrayData) {
            return array
        } else {
            return [:]
        }
        } else{
            return [:]
        }
    }

    
    // Set the spacing between sections
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.entries[formmattedDate!]!.count
        }
        
        // There is just one row in every section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Make the background color show through
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = UIColor.clear
          return headerView
      }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entryArrays = self.entries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]
        
        let text = currentEntry.text as NSString
           let labelWidth = tableView.frame.width - 32 // Adjust the width as per your layout
           let titleLabelHeight: CGFloat = 20 // Adjust the height of the title label as per your preference
           let font = UIFont.systemFont(ofSize: 17) // Adjust the font size as per your preference
        let entryHeight = text.height(withConstrainedWidth: labelWidth, font: font)
           let cellHeight = titleLabelHeight + entryHeight + 24 // Add extra padding as per your preference

           return cellHeight
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = self.entries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        cell.titleLabel.text = entry.mood
        cell.entryLabel.text = entry.text
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }






}

