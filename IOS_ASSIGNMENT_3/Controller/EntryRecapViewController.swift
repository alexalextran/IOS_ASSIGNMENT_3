import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate: Date?
    var formattedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the cell class for the collection view
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
    }
    
    // Implement UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in the month
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let day = indexPath.item + 1
        cell.setupCell(day: day)
        cell.button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    
    //JOSH DO NOT TOUCH THIS FUNCTION
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
