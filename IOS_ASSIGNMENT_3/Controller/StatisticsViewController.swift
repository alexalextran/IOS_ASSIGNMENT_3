import UIKit

class StatisticsViewController: UIViewController {
    
    struct Entry: Codable {
        var mood: String
        var text: String
    }
    
    let KEY_DAILY_ENTRIES = "dailyEntries"
    var entries = [String: [Entry]]()
    var entriesThisMonth = [Entry]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        entries = readEntries()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentMonth = getCurrentMonth()
        
        entriesThisMonth = entries.filter { (dateString, _) -> Bool in
            guard let date = dateFormatter.date(from: dateString) else {
                return false
            }
            let month = Calendar.current.component(.month, from: date)
            return month == currentMonth
        }.flatMap { $0.value }
        
        
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
    
    func readEntries() -> [String: [Entry]] {
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data,
           let array = try? PropertyListDecoder().decode([String: [Entry]].self, from: savedArrayData) {
            return array
        } else {
            return [:]
        }
    }
    
    func getCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let currentMonth = dateFormatter.string(from: Date())
        return Int(currentMonth) ?? 0
    }
    
    func calculateMoodPercentage(emotion: String) -> String {
        let moodToCalculate = emotion
        let totalCount = entriesThisMonth.count
        let emotionCount = entriesThisMonth.filter { $0.mood == moodToCalculate }.count
        let percentage = (Double(emotionCount) / Double(totalCount) * 100.0)
        
        print("Sad Mood Count: \(emotionCount), Percentage: \(percentage)%")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        guard let roundedNumber = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return ""
        }
        
        return roundedNumber
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
}
