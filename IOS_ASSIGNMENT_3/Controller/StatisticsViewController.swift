import UIKit

class StatisticsViewController: UIViewController {
    
    struct Entry: Codable {
        var mood: String
        var text: String
    }
    

    
    let KEY_DAILY_ENTRIES = "dailyEntries"
    var entries = [String: [Entry]]()
    var entriesThisMonth = [Entry]()
    

 
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
        sadPercentage.text = String(calculateMoodPercentage(emotion: "Sad"))
        neutralPercentage.text = String(calculateMoodPercentage(emotion: "Neutral"))
        goodPercentage.text = String(calculateMoodPercentage(emotion: "Good"))
        joyPercentage.text = String(calculateMoodPercentage(emotion: "Joy"))
        
        
        
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
    
    func calculateMoodPercentage(emotion:String) -> Double {
        let moodToCalculate = emotion
        let totalCount = entriesThisMonth.count
        let emotionCount = entriesThisMonth.filter { $0.mood == moodToCalculate }.count
        let percentage = (Double(emotionCount) / (Double(totalCount)) * 100.0)
        
        print("Sad Mood Count: \(emotionCount), Percentage: \(percentage)%")
        
        return percentage
    }
}
