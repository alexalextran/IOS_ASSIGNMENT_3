import UIKit

class StatisticsViewController: UIViewController {
    
    struct Entry: Codable {
        var mood: String
        var text: String
    }
    
    let KEY_DAILY_ENTRIES = "dailyEntries"
    var entries = [String: [EntryManager.Entry]]()
    var entriesThisMonth = [EntryManager.Entry]()
    
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var PreviousMonth: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
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
    var entryManager =  EntryManager()
    
    var i:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        entries = entryManager.readEntries()
        
        i = getCurrentMonth()
        updateCurrentMonthAndYearLabel()
        updateStatistics()
        setUpUI()
        
        PreviousMonth.addTarget(self, action: #selector(previousMonthButtonTapped(_:)), for: .touchUpInside)
        NextMonth.addTarget(self, action: #selector(nextMonthButtonTapped(_:)), for: .touchUpInside)
        
    }
    
  
    
    func updateCurrentMonthAndYearLabel() {
        guard (1...12).contains(i) else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Set the date format to display the full month name and year

        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonthComponents = DateComponents(year: currentYear, month: i)
        guard let currentMonthDate = calendar.date(from: currentMonthComponents) else {
            print("Invalid current month date.")
            return
        }

        monthLabel.text = dateFormatter.string(from: currentMonthDate)
    }
    
    
    
    // Decreases the value of i by 1 and moves to the previous month
    @objc func previousMonthButtonTapped(_ sender: UIButton) {
        i -= 1
        // Ensure i stays within the range of 1-12
        if i < 1 {
            i = 12
        }
        // Update the label to the current month and year
        updateCurrentMonthAndYearLabel()
        updateStatistics()
    }

    // Increases the value of i by 1 and moves to the next month
    @objc func nextMonthButtonTapped(_ sender: UIButton) {
        i += 1
        // Ensure i stays within the range of 1-12
        if i > 12 {
            i = 1
        }
        // Update the label to the current month and year
        updateCurrentMonthAndYearLabel()
        updateStatistics()
    }
    
    func updateStatistics() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentMonth = i

        // Filter entries for the current month
        entriesThisMonth = entries.filter { (dateString, _) -> Bool in
            
            // Convert the date string to a Date object
            guard let date = dateFormatter.date(from: dateString) else {
                return false
            }
            // Extract the month component from the date
            let month = Calendar.current.component(.month, from: date)

            // Check if the extracted month matches the current month
            return month == currentMonth
        }.flatMap { $0.value }

        setUpUI()
    }
    
    func getCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM" //get current month
        let currentMonth = dateFormatter.string(from: Date())
        return Int(currentMonth) ?? 0 //return current month as a number
    }
    
    func calculateMoodPercentage(emotion: String) -> String {
        let moodToCalculate = emotion
        let totalCount = entriesThisMonth.count //get total entries this month
        let emotionCount = entriesThisMonth.filter { $0.mood == moodToCalculate }.count //count all entries that 
        let percentage = (Double(emotionCount) / Double(totalCount) * 100.0)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1 //format to one deciaml
        
        let roundedNumber = numberFormatter.string(from: NSNumber(value: percentage))
        
        return roundedNumber!
    }
    
    func getDaysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        
        guard let firstDayOfMonth = calendar.date(from: dateComponents),
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth),
              let daysInMonth = calendar.dateComponents([.day], from: firstDayOfMonth, to: nextMonth).day else {
            return 0
        }
        
        return daysInMonth
    }
    
    
    
    func setUpUI(){
        unhappyPercentage.text = String(calculateMoodPercentage(emotion: "Unhappy"))
        unhappyPogressBar.progress = Float(unhappyPercentage.text!)! * 0.01
        
        sadPercentage.text = String(calculateMoodPercentage(emotion: "Sad"))
        sadPogressBar.progress = Float(sadPercentage.text!)! * 0.01
        
        neutralPercentage.text = String(calculateMoodPercentage(emotion: "Neutral"))
        neutralPogressBar.progress = Float(neutralPercentage.text!)! * 0.01
        
        goodPercentage.text = String(calculateMoodPercentage(emotion: "Good"))
        goodPogressBar.progress = Float(goodPercentage.text!)! * 0.01
        
        joyPercentage.text = String(calculateMoodPercentage(emotion: "Joy"))
        joyPogressBar.progress = Float(joyPercentage.text!)! * 0.01
        
        totalEntriesLabel.text = String(entriesThisMonth.count)
        
        let daysInMonth = getDaysInCurrentMonth()
        let averageEntries = Double(entriesThisMonth.count) / Double(daysInMonth)
        averageEntriesLabel.text = String(format: "%.1f", averageEntries)
        
        
    }
}
