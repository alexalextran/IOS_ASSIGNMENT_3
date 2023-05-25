import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var PreviousMonth: UIButton!
    @IBOutlet weak var GoButtonForRecap: UIButton!
    @IBOutlet weak var CurrentMonthandYear: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let monthsDictionary =
    [1: 31,
     2: 28,
     3: 31,
     4: 30,
     5: 31,
     6: 30,
     7: 31,
     8: 31,
     9: 30,
     10: 31,
     11: 30,
     12: 31]
    
    var i:Int = 0
    var selectedDate: Date?
    var formattedDate: String?
    var selectedIndexPath: IndexPath?
    struct Entry: Codable{
           var mood:String
           var text:String
       }
       var entries = [String: [Entry]]()
       let KEY_DAILY_ENTRIES = "dailyEntries"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentMonthAndYearLabel()
        
        PreviousMonth.addTarget(self, action: #selector(previousMonthButtonTapped(_:)), for: .touchUpInside)
        
        NextMonth.addTarget(self, action: #selector(nextMonthButtonTapped(_:)), for: .touchUpInside)

        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the cell class for the collection view
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        let currentDate = Date()
        let calendar = Calendar.current

        let currentMonth = calendar.component(.month, from: currentDate)
        print("Current month (digit): \(currentMonth)")
        
        i = currentMonth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        CurrentMonthandYear.text =  dateFormatter.string(from: Date()) + " 2023"
        GoButtonForRecap.isEnabled = false
        
        entries = readEntries()
        print(entries)
    }
    //alol
    func readEntries() -> [String: [Entry]] {
        let defaults = UserDefaults.standard

        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data,
           let array = try? PropertyListDecoder().decode([String: [Entry]].self, from: savedArrayData) {
            return array
        } else {
            return [:]
        }
    }
    
    /*func checkCalendarCompleteness() {
        // Loop through the calendar dictionary
        for (_, daysInMonth) in monthsDictionary {
            for day in 1...daysInMonth {
                let dateComponents = DateComponents(year: 2023, month: i, day: day)
                if let date = Calendar.current.date(from: dateComponents) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let formattedDate = dateFormatter.string(from: date)
                    
                    // Check if the date exists in the dictionary
                    if entries[formattedDate] == nil {
                        // Disable the "go" button
                        goButton.isEnabled = false
                        return
                    }
                }
            }
        }
        
        // Enable the "go" button if all dates exist in the dictionary
        goButton.isEnabled = true
    }*/

   
    
    func updateCurrentMonthAndYearLabel() {
        guard (1...12).contains(i) else {
            print("Invalid month index: \(i)")
            return
        }
        
        let monthSymbols = DateFormatter().monthSymbols
        let monthIndex = i - 1
        
        if let monthName = monthSymbols?[monthIndex] {
            let currentYear = Calendar.current.component(.year, from: Date())
            CurrentMonthandYear.text = "\(monthName) \(currentYear)"
        } else {
            print("Month name not found for index: \(monthIndex)")
        }
    }
    
    //decreases the value of i by 1 and therefore moving to the previous month
    @objc func previousMonthButtonTapped(_ sender: UIButton) {
            // Decrease the value of i by 1
            i -= 1
            
            // Ensure i stays within the range of 1-12
            if i < 1 {
                i = 12
            }
            
            // Reload the collection view to reflect the updated month
            collectionView.reloadData()
        
            //update the label to the current month and year
            updateCurrentMonthAndYearLabel()

        }
    
    //increases the value of i by 1 and therefore moving to the next month
    @objc func nextMonthButtonTapped(_ sender: UIButton) {
            // Increase the value of i by 1
            i += 1
            
            // Ensure i stays within the range of 1-12
            if i > 12 {
                i = 1
            }
            
            // Reload the collection view to reflect the updated month
            collectionView.reloadData()
        
            //update the label to the current month and year
            updateCurrentMonthAndYearLabel()

        }
    
    // Implement UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in the month
        let month = (i - 1) % 12 + 1
        if let daysInMonth = monthsDictionary[month] {
            return daysInMonth
        } else {
            // Provide a default value (e.g., 30) or handle the error case
            return 30
        }
    }
    
    func updateSaveButtonState() {
            if selectedDate == nil {
                GoButtonForRecap.isEnabled = false
            } else {
                GoButtonForRecap.isEnabled = true
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let day = indexPath.item + 1
        cell.setupCell(day: day)
        cell.button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        
        // Reset the button's appearance for each cell
        cell.button.backgroundColor = .clear
        cell.button.setTitleColor(.black, for: .normal)
        
        let selectedMonth = i // Assuming May for this example
        let selectedYear = 2023 // Assuming the current year for this example
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: day)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = Calendar.current.date(from: dateComponents) {
            let formattedDate = dateFormatter.string(from: date)
            if entries[formattedDate] == nil {
                // Disable the button and gray it out
                cell.button.isEnabled = false
                cell.button.setTitleColor(.gray, for: .disabled)
            } else {
                // Enable the button
                cell.button.isEnabled = true
            }
        } else {
            // Handle invalid date or formatting error
        }
        
        return cell
    }

    
    
    @objc func dateButtonTapped(_ sender: UIButton) {
        //bruh
        if let cell = sender.superview?.superview as? DateCell {
            let indexPath = collectionView.indexPath(for: cell)!
            let selectedDay = indexPath.item + 1
            let selectedMonth = i // Assuming May for this example
            let selectedYear = 2023 // Assuming the current year for this example

            // Create a date using the selected day, month, and year
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = selectedYear
            dateComponents.month = selectedMonth
            dateComponents.day = selectedDay
            selectedDate = calendar.date(from: dateComponents)

            // Update the previously selected button appearance
            if let previousIndexPath = selectedIndexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? DateCell {
                    previousCell.button.backgroundColor = .clear
                    previousCell.button.setTitleColor(.black, for: .normal)
                }
            }

            // Update the current button appearance
            cell.button.backgroundColor = .blue
            cell.button.setTitleColor(.white, for: .normal)
            
            updateSaveButtonState()

            selectedIndexPath = indexPath

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let selectedDate = selectedDate {
                let formattedDate = dateFormatter.string(from: selectedDate)
                self.formattedDate = formattedDate
                print(formattedDate)
            }
        }
    }


    
    
    class DateCell: UICollectionViewCell {
        let button = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupCell()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupCell()
        }
        
        private func setupCell() {
            contentView.addSubview(button)
            button.frame = contentView.bounds
            button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Customize the appearance of the button
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        func setupCell(day: Int) {
            button.setTitle("\(day)", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGetEntries" {
            let VC = segue.destination as! GetEntriesViewController
            VC.date = selectedDate
            VC.formmattedDate = formattedDate
        }
    }
    
}
