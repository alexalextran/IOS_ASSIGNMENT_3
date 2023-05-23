import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate: Date?
    
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
        return 31 // Implement your own logic to determine the number of days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let day = indexPath.item + 1
        cell.setupCell(day: day)
        return cell
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
    
}
