import UIKit

class GetEntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var date: Date?
    var formmattedDate: String?
    let cellReuseIdentifier = "cell"

    @IBOutlet weak var entriesTable: UITableView!
    @IBOutlet weak var filterTextField: UITextField!

    struct Entry: Codable {
        var mood: String
        var text: String
    }

    let KEY_DAILY_ENTRIES = "dailyEntries"
    var entries = [String: [Entry]]()
    var filteredEntries = [String: [Entry]]()

    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        dateLabel.text = formmattedDate

        self.entriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        entriesTable.delegate = self
        entriesTable.dataSource = self

        entries = readEntries()
        filteredEntries = entries

        filterTextField.delegate = self
        filterTextField.addTarget(self, action: #selector(filterTextFieldDidChange(_:)), for: .editingChanged)
    }

    // Filter entries when the filter text field value changes
    @objc func filterTextFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if searchText.isEmpty {
            filteredEntries = entries
        } else {
            filteredEntries = entries.mapValues { $0.filter { $0.text.contains(searchText) } }
        }
        entriesTable.reloadData()
    }

    func readEntries() -> [String: [Entry]] {
        let defaults = UserDefaults.standard

        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data,
           let array = try? PropertyListDecoder().decode([String: [Entry]].self, from: savedArrayData) {
            return array
        } else {
            return [:]
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredEntries[formmattedDate!]?.count ?? 0
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
        let entryArrays = filteredEntries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]

        let text = currentEntry.text as NSString
        let labelWidth = tableView.frame.width - 32 // Adjust the width as per your layout
        let titleLabelHeight: CGFloat = 20 // Adjust the height of the title label as per your preference
        let font = UIFont.systemFont(ofSize: 17) // Adjust the font size as per your preference
        let entryHeight = text.height(withConstrainedWidth: labelWidth, font: font)
        let cellHeight = titleLabelHeight + entryHeight + 44 // Add extra padding as per your preference

        return cellHeight
    }
    
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let section = sender.tag // Get the section index from the button's tag
        let entryArrays = self.entries[formmattedDate!]
        
        if var sectionEntries = entryArrays, sectionEntries.indices.contains(section) {
            sectionEntries.remove(at: section) // Remove the entry from the array
            
            // Update the entries and filteredEntries dictionaries
            entries[formmattedDate!] = sectionEntries
            filteredEntries[formmattedDate!] = sectionEntries
            
            // Save the updated entries to UserDefaults or any other storage mechanism
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
            
            // Reload the table view
            entriesTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = filteredEntries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        cell.titleLabel.text = entry.mood
        cell.entryLabel.text = entry.text
        
        switch entry.mood {
        case "Unhappy":
            cell.layer.borderColor = UIColor.systemOrange.cgColor
        case "Sad":
            cell.layer.borderColor = UIColor.systemTeal.cgColor
        case "Neutral":
            cell.layer.borderColor = UIColor.systemPurple.cgColor
        case "Good":
            cell.layer.borderColor = UIColor.systemGreen.cgColor
        case "Joy":
            cell.layer.borderColor = UIColor.systemYellow.cgColor
        default:
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        let customColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        cell.backgroundColor = customColor
   
        cell.layer.borderWidth = 2.2
        cell.layer.cornerRadius = 14
       
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100))
           cell.contentView.clipsToBounds = true
        
        
        
        
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "xmark") // Use the system icon "xmark"
        button.setImage(deleteImage, for: .normal)
        button.tintColor = UIColor.black // Set the tint color to black
        button.frame = CGRect(x: cell.bounds.width - 30, y: 10, width: 20, height: 20) // Adjust the button's frame as per your preference
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside) // Add target action
        button.tag = indexPath.section // Set the tag to identify the button

        cell.addSubview(button)

        return cell
    }
}
