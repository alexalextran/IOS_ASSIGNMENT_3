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


class DRecapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var entriesTable: UITableView!
    
    var moodE:String?
    var textE:String?
    var formmattedDate:String?
    var entries = [String: [EntryManager.Entry]]()
    let cellReuseIdentifier = "cell"
    var entryManager =  EntryManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entries = entryManager.readEntries()
        entriesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = entryManager.readEntries()
        writeEntry()
        self.entriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        entriesTable.delegate = self
        entriesTable.dataSource = self
        entriesTable.layer.cornerRadius = 14
        entriesTable.layer.masksToBounds = true
    }
    
    
    
    
    func writeEntry() {
        let newEntry = EntryManager.Entry(mood: moodE!, text: textE!) //create new entry object
        if entries[formmattedDate!] != nil { //if the date does not already exist make a new entry within the dict
            entries[formmattedDate!]!.append(newEntry)
        } else {
            entries[formmattedDate!] = [newEntry]
        }
        entryManager.writeEntry(entries: entries) //write to database
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entries[formmattedDate!]?.count ?? 0 //populate entry tableiew
        }
        
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //make each entry as a section for spacing
            return 1
        }
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //heading height (spacing between each entry
            return 40
        }
    
  
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {   // Make the background color show through
          let headerView = UIView()
          headerView.backgroundColor = UIColor.clear
          return headerView
      }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //set up entry height
        let entryArrays = self.entries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]
        
        let text = currentEntry.text as NSString
        let labelWidth = tableView.frame.width - 32 //label width
        let titleLabelHeight: CGFloat = 20 //title height
        let font = UIFont.systemFont(ofSize: 18) //font size
        let entryHeight = text.height(withConstrainedWidth: labelWidth, font: font)
        let cellHeight = titleLabelHeight + entryHeight + 44 //padding
        
        return cellHeight //dynamic height based on text
    }
    
    
    @objc func deleteButtonTapped(_ sender: UIButton) {  //handle delete button
        let section = sender.tag // Get the section index from the button's tag
        let entryArrays = self.entries[formmattedDate!]

        if var sectionEntries = entryArrays, sectionEntries.indices.contains(section) {
            sectionEntries.remove(at: section) //remove entry from array

            // update entries dict
            entries[formmattedDate!] = sectionEntries
           

            // if there are no remaining entries for a date, remove the date itself from the dict
            if sectionEntries.isEmpty {
                entries.removeValue(forKey: formmattedDate!)

            }

            // update to database
            entryManager.writeEntry(entries: entries)

            // refresh tableview
            entriesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set up cells
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = self.entries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        cell.titleLabel.text = entry.mood  //set up entry labels
        cell.entryLabel.text = entry.text
        cell.titleLabel.textColor = UIColor.label
        cell.entryLabel.textColor = UIColor.label
        
        cell.layer.borderColor = setBorderColor(entryMood: entry.mood) // setup bubble

        cell.backgroundColor = UIColor(named: "lightDarkColor")
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 14
        cell.contentView.clipsToBounds = true
        
        // add "x" button (delete button)
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "xmark") // use system icon
        button.setImage(deleteImage, for: .normal)
        button.tintColor = UIColor.label //color
        button.frame = CGRect(x: cell.bounds.width - 30, y: 10, width: 20, height: 20) //size and positioning
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        button.tag = indexPath.section  //add entry tag so we can use for later
        cell.addSubview(button)
        
        return cell
    }
    
    func setBorderColor(entryMood:String) -> CGColor {  //set border color
        switch entryMood{
        case "Unhappy":
           return UIColor.systemRed.cgColor
        case "Sad":
            return UIColor.systemTeal.cgColor
        case "Neutral":
            return UIColor.systemPurple.cgColor
        case "Good":
            return UIColor.systemGreen.cgColor
        case "Joy":
            return UIColor.systemYellow.cgColor
        default:
            return UIColor.black.cgColor
        }
        
    }







}
