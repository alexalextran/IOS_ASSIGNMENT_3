import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate {
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var PreviousMonth: UIButton!
    @IBOutlet weak var GoButtonForRecap: UIButton!
    @IBOutlet weak var CurrentMonthandYear: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let pink = UIColor(red: 254/255, green: 58/255, blue: 92/255, alpha: 1.0)
    
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
    
    var i:Int = 1
    var selectedDate: Date?
    var formattedDate: String?
    var selectedIndexPath: IndexPath?
    struct Entry: Codable{
           var mood:String
           var text:String
       }
    var entries = [String: [EntryManager.Entry]]()
    var entryManager =  EntryManager()
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        updateCurrentMonthAndYearLabel()
        PreviousMonth.addTarget(self, action: #selector(previousMonthButtonTapped(_:)), for: .touchUpInside)
        NextMonth.addTarget(self, action: #selector(nextMonthButtonTapped(_:)), for: .touchUpInside)

        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the cell class for the collection view
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        //set i to current month but as an integer
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        i = currentMonth
        
        //format label to month as in May
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        CurrentMonthandYear.text =  dateFormatter.string(from: Date()) + " 2023"
        GoButtonForRecap.isEnabled = false
        entries = entryManager.readEntries()
        refreshPage()
        collectionView.layer.cornerRadius = 8.0
        collectionView.layer.masksToBounds = true
    }
    
    
    func refreshPage() {
        // Reset properties to their initial values
        selectedDate = nil
        formattedDate = nil
        selectedIndexPath = nil

        // Reload the collection view
        collectionView.reloadData()

        // Update other UI elements or perform any additional tasks if needed
        updateSaveButtonState()
        updateCurrentMonthAndYearLabel()
    }
    
    
    //set current month and year labels
    func updateCurrentMonthAndYearLabel() {
        guard (1...12).contains(i) else {
            return
        }
        let monthSymbols = DateFormatter().monthSymbols
        let monthIndex = i
        if let monthName = monthSymbols?[monthIndex - 1] {
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in the month
        if let daysInMonth = monthsDictionary[i] {
            return daysInMonth
        } else {
            return 0
        }
    }
    
    //only enable savebutton if the user has selected a date
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
        cell.button.setTitleColor(pink, for: .normal)

        let selectedMonth = i
        let selectedYear = 2023
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
                // Enable the button and set its appearance
                cell.button.isEnabled = true

                if formattedDate == self.formattedDate {
                    // Highlight the button for the currently selected date
                    cell.button.backgroundColor = UIColor(named: "darkLight")

                    cell.button.setTitleColor(pink, for: .normal)
                }
            }
        }

        return cell
    }


    
    
    @objc func dateButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? DateCell {
            let indexPath = collectionView.indexPath(for: cell)!
            //use index as the day
            let selectedDay = indexPath.item + 1
            let selectedMonth = i
            let selectedYear = 2023
            
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
                    previousCell.button.setTitleColor(pink, for: .normal)
                }
            }

            // Update the current button appearance
          
            cell.button.backgroundColor = UIColor(named: "darkLight")
              
            cell.button.setTitleColor(pink, for: .normal)
            
    
            updateSaveButtonState()
            selectedIndexPath = indexPath
            
            //format date and set formmatted date to the selected date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let selectedDate = selectedDate {
                let formattedDate = dateFormatter.string(from: selectedDate)
                self.formattedDate = formattedDate
            }
        }
    }


//send selectedDate and formmattedDate over to GetEntries
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGetEntries" {
            let VC = segue.destination as! GetEntriesViewController
            VC.date = selectedDate
            VC.formmattedDate = formattedDate
        }
    }
    
}
