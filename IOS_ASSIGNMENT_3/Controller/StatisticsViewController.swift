//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 12/5/2023.
//



import UIKit

class StatisticsViewController: UIViewController {
    
    var entries = [String: [EntryManager.Entry]]()
    var entriesThisMonth = [EntryManager.Entry]()
    
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var PreviousMonth: UIButton!
    @IBOutlet weak var CurrentMonthandYear: UILabel!
    @IBOutlet weak var totalEntriesLabel: UILabel!
    @IBOutlet weak var averageEntriesLabel: UILabel!
    @IBOutlet weak var unhappyPogressBar: UIProgressView!
    @IBOutlet weak var sadPogressBar: UIProgressView!
    @IBOutlet weak var neutralPogressBar: UIProgressView!
    @IBOutlet weak var goodPogressBar: UIProgressView!
    @IBOutlet weak var joyPogressBar: UIProgressView!
    @IBOutlet weak var unhappyPercentage: UILabel!
    @IBOutlet weak var sadPercentage: UILabel!
    @IBOutlet weak var neutralPercentage: UILabel!
    @IBOutlet weak var goodPercentage: UILabel!
    @IBOutlet weak var joyPercentage: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    let dateFunctions = DateFunctions()
    let entryManager =  EntryManager()
    
    var i:Int = 0 //use i as a way to keep track of the current month
    
    let monthsDictionary = //store how many daays are in each month
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        entries = entryManager.readEntries()
        i = dateFunctions.getCurrentMonth()
        CurrentMonthandYear.text = dateFunctions.updateCurrentMonthAndYearLabel(i: i)
        updateStatistics()
        setUpUI()
        
        PreviousMonth.addTarget(self, action: #selector(previousMonthButtonTapped(_:)), for: .touchUpInside)
        NextMonth.addTarget(self, action: #selector(nextMonthButtonTapped(_:)), for: .touchUpInside)
    }
    
    //decreases i by 1 to represent previous month
    @objc func previousMonthButtonTapped(_ sender: UIButton) {
        i -= 1
            //ensure i stays in the range of the months
        if i < 1 {
            i = 12
        }
        // Update the label to the current month and year annd all the statistic labels
        CurrentMonthandYear.text = dateFunctions.updateCurrentMonthAndYearLabel(i: i)
        updateStatistics()
    }

    //decreases i by 1 to represent previous month
    @objc func nextMonthButtonTapped(_ sender: UIButton) {
        i += 1
        //ensure i stays in the range of the months
        if i > 12 {
            i = 1
        }
        // Update the label to the current month and year annd all the statistic labels
        CurrentMonthandYear.text = dateFunctions.updateCurrentMonthAndYearLabel(i: i)
        updateStatistics()
    }
    
    
    func updateStatistics() { //updates statisitcs based on the current month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentMonth = i

        // Filter entries based on current month
        entriesThisMonth = entries.filter { (dateString, _) -> Bool in
            
            // convert date string to date object
            guard let date = dateFormatter.date(from: dateString) else {
                return false
            }
            // extract month
            let month = Calendar.current.component(.month, from: date)

            // check if entry month is equal to current month
            return month == currentMonth
        }.flatMap { $0.value }
        setUpUI() //update UI
    }
    
    
    
    //formula for mood percentage
    func calculateMoodPercentage(emotion: String) -> String {
        let moodToCalculate = emotion
        let totalCount = entriesThisMonth.count
        let emotionCount = entriesThisMonth.filter { $0.mood == moodToCalculate }.count //filter by Entry.mood

        guard totalCount != 0 else {
            return "0"
        }

        let percentage = (Double(emotionCount) / Double(totalCount) * 100.0)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1 //limit percentge to 1 decimal place

        let roundedNumber = numberFormatter.string(from: NSNumber(value: percentage))
        return roundedNumber ?? "0"
    }

    
    func setUpUI() { // sets percentage text and pogress bars to the value of mood percentage
        
        PreviousMonth.layer.cornerRadius = 8
        NextMonth.layer.cornerRadius = 8
        
        topStackView.layer.cornerRadius = 8
        topStackView.clipsToBounds = true
        
        middleStackView.layer.cornerRadius = 8
        middleStackView.clipsToBounds = true
        
        bottomStackView.layer.cornerRadius = 8
        bottomStackView.clipsToBounds = true
        
        
        let unhappyPercentageValue = calculateMoodPercentage(emotion: "Unhappy")
        unhappyPercentage.text = unhappyPercentageValue + "%"
        unhappyPogressBar.progress = Float(unhappyPercentageValue)! / 100.0

        let sadPercentageValue = calculateMoodPercentage(emotion: "Sad")
        sadPercentage.text = sadPercentageValue + "%"
        sadPogressBar.progress = Float(sadPercentageValue)! / 100.0

        let neutralPercentageValue = calculateMoodPercentage(emotion: "Neutral")
        neutralPercentage.text = neutralPercentageValue + "%"
        neutralPogressBar.progress = Float(neutralPercentageValue)! / 100.0

        let goodPercentageValue = calculateMoodPercentage(emotion: "Good")
        goodPercentage.text = goodPercentageValue + "%"
        goodPogressBar.progress = Float(goodPercentageValue)! / 100.0

        let joyPercentageValue = calculateMoodPercentage(emotion: "Joy")
        joyPercentage.text = joyPercentageValue + "%"
        joyPogressBar.progress = Float(joyPercentageValue)! / 100.0

        totalEntriesLabel.text = String(entriesThisMonth.count)

        let daysInMonth = monthsDictionary[i]
        let averageEntries = Double(entriesThisMonth.count) / Double(daysInMonth!)
        averageEntriesLabel.text = String(format: "%.1f", averageEntries)
        
    }

}
