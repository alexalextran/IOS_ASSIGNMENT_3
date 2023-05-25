import Foundation

class EntryManager{
    let KEY_DAILY_ENTRIES = "dailyEntries"
    
    struct Entry: Codable{
        var mood:String
        var text:String
    }
    
    func writeEntry(entries: [String: [Entry]]) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
    }
    
    
    func readEntries() -> [String: [Entry]]{
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data{ if let array = try? PropertyListDecoder().decode([String: [Entry]].self,from: savedArrayData) {
            return array
        } else {
            return [:]
        }
        } else{
            return [:]
        }
    }
    
    
}
