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
    let dateFunctions = DateFunctions()
    var entries = [String: [EntryManager.Entry]]()
    let entryManager =  EntryManager()
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        updateCurrentMonthAndYearLabel()
        PreviousMonth.addTarget(self, action: #selector(previousMonthButtonTapped(_:)), for: .touchUpInside)
        NextMonth.addTarget(self, action: #selector(nextMonthButtonTapped(_:)), for: .touchUpInside)
        PreviousMonth.layer.cornerRadius = 8
        NextMonth.layer.cornerRadius = 8

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        //set i to current month but as an integer
        i = dateFunctions.getCurrentMonth()
        //set title label to month depending on i
        CurrentMonthandYear.text = dateFunctions.updateCurrentMonthAndYearLabel(i:i)
        GoButtonForRecap.isEnabled = false
        entries = entryManager.readEntries()
        refreshPage()
        
        collectionView.layer.cornerRadius = 8.0
        collectionView.layer.masksToBounds = true
    }
    
    
    func refreshPage() {
        // reset properties
        selectedDate = nil
        formattedDate = nil
        selectedIndexPath = nil

        //refresh collectionview
        collectionView.reloadData()

        // updateUI
        updateSaveButtonState()
        updateCurrentMonthAndYearLabel()
    }
    
    
    func updateCurrentMonthAndYearLabel() {
        CurrentMonthandYear.text = dateFunctions.updateCurrentMonthAndYearLabel(i: i)
    }
    
 
    
    //decreases i by 1 to represent previous month
    @objc func previousMonthButtonTapped(_ sender: UIButton) {
            // Decrease the value of i by 1
            i -= 1
        //ensure i stays in the range of the months
            if i < 1 {
                i = 12
            }
        // Update the label to the current month and year annd all the statistic labels
            collectionView.reloadData()
            updateCurrentMonthAndYearLabel()
        }
    
    //decreases i by 1 to represent previous month
    @objc func nextMonthButtonTapped(_ sender: UIButton) {
            i += 1
        //ensure i stays in the range of the months
            if i > 12 {
                i = 1
            }
        // Update the label to the current month and year annd all the statistic labels
            collectionView.reloadData()
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
                //disable button if date does not exist in dict
                cell.button.isEnabled = false
                cell.button.setTitleColor(.gray, for: .disabled)
            } else {
                // enable button if it does exist
                cell.button.isEnabled = true

                if formattedDate == self.formattedDate {
                    // highlight selected date
                    cell.button.backgroundColor = pink

                    cell.button.setTitleColor(.white, for: .normal)
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
            cell.button.backgroundColor = pink
            cell.button.setTitleColor(.white, for: .normal)
    
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
