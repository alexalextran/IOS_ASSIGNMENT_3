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
    
    var i:Int = 0 //use i as a way to keep track of the current month
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        entries = entryManager.readEntries()
        
        i = getCurrentMonth() //set i to the current month e.g if it was may i = 5
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
        setUpUI() //update UI
    }
    
    func getCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM" //get current month
        let currentMonth = dateFormatter.string(from: Date())
        return Int(currentMonth) ?? 0 //return current month as a number
    }
    
    func calculateMoodPercentage(emotion: String) -> String {
        let moodToCalculate = emotion
        let totalCount = entriesThisMonth.count // get total entries this month
        let emotionCount = entriesThisMonth.filter { $0.mood == moodToCalculate }.count // count all entries that match the mood

        // Handle the case where there are no entries of the specific mood
        guard totalCount != 0 else {
            return "0"
        }

        let percentage = (Double(emotionCount) / Double(totalCount) * 100.0)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1 // format to one decimal

        let roundedNumber = numberFormatter.string(from: NSNumber(value: percentage))

        return roundedNumber ?? "0"
    }

    
    func getDaysInCurrentMonth() -> Int { //return the days within the selected month
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
    
    
    
    func setUpUI() {
        let unhappyPercentageValue = calculateMoodPercentage(emotion: "Unhappy")
        unhappyPercentage.text = unhappyPercentageValue
        unhappyPogressBar.progress = Float(unhappyPercentageValue)! / 100.0

        let sadPercentageValue = calculateMoodPercentage(emotion: "Sad")
        sadPercentage.text = sadPercentageValue
        sadPogressBar.progress = Float(sadPercentageValue)! / 100.0

        let neutralPercentageValue = calculateMoodPercentage(emotion: "Neutral")
        neutralPercentage.text = neutralPercentageValue
        neutralPogressBar.progress = Float(neutralPercentageValue)! / 100.0

        let goodPercentageValue = calculateMoodPercentage(emotion: "Good")
        goodPercentage.text = goodPercentageValue
        goodPogressBar.progress = Float(goodPercentageValue)! / 100.0

        let joyPercentageValue = calculateMoodPercentage(emotion: "Joy")
        joyPercentage.text = joyPercentageValue
        joyPogressBar.progress = Float(joyPercentageValue)! / 100.0

        totalEntriesLabel.text = String(entriesThisMonth.count)

        let daysInMonth = getDaysInCurrentMonth()
        let averageEntries = Double(entriesThisMonth.count) / Double(daysInMonth)
        averageEntriesLabel.text = String(format: "%.1f", averageEntries)

        // Check if mood percentages are zero and update progress bars and labels accordingly
        if unhappyPercentageValue == "0" {
            unhappyPogressBar.progress = 0
            unhappyPercentage.text = "0"
        }
        if sadPercentageValue == "0" {
            sadPogressBar.progress = 0
            sadPercentage.text = "0"
        }
        if neutralPercentageValue == "0" {
            neutralPogressBar.progress = 0
            neutralPercentage.text = "0"
        }
        if goodPercentageValue == "0" {
            goodPogressBar.progress = 0
            goodPercentage.text = "0"
        }
        if joyPercentageValue == "0" {
            joyPogressBar.progress = 0
            joyPercentage.text = "0"
        }
    }

}
