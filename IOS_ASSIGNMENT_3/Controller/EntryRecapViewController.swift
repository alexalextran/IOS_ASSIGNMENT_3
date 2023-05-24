import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var PreviousMonth: UIButton!
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
        
    }
    func updateCurrentMonthAndYearLabel() {
        let monthName = DateFormatter().monthSymbols[i - 1]
        let currentYear = Calendar.current.component(.year, from: Date())
        CurrentMonthandYear.text = "\(monthName) \(currentYear)"
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
      
        return monthsDictionary[i]!
        
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let day = indexPath.item + 1
        cell.setupCell(day: day)
        cell.button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    
    //JOSH DO NOT TOUCH THIS FUNCTION... ok
    @objc func dateButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? DateCell {
            let indexPath = collectionView.indexPath(for: cell)!
            let selectedDay = indexPath.item+1
            let selectedMonth = 5 // Assuming May for this example
            let selectedYear = 2023 // Assuming the current year for this example

            // Create a date using the selected day, month, and year
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = selectedYear
            dateComponents.month = selectedMonth
            dateComponents.day = selectedDay
            selectedDate = calendar.date(from: dateComponents)

            // Update the button appearance or perform any additional actions here if needed
            collectionView.reloadData()
            let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    if let selectedDate = selectedDate {
                        let FormattedDate = dateFormatter.string(from: selectedDate)
                        formattedDate = FormattedDate
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
