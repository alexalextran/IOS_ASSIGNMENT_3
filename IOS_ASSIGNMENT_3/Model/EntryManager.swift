import Foundation

class EntryManager {
    let KEY_DAILY_ENTRIES = "dailyEntries"
    
    struct Entry: Codable {
        var mood: String
        var text: String
    }
    
    func writeEntry(entries: [String: [Entry]]) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
    }
    
    func injectFakeData() -> [String: [Entry]] {
        let fakeData: [String: [Entry]] = [
            "14/03/2023": [
                Entry(mood: "Sad", text: "I'm very sad today. I lost my 100-metre sprint during my athletics carnival."),
                Entry(mood: "Neutral", text: "I'm feeling a bit better. I ate some food and watched some TV.")
            ],
            "25/03/2023": [
                Entry(mood: "Happy", text: "I just received my marks for my assignment, and it showed I got 98%. I'm so happy right now!"),
                Entry(mood: "Neutral", text: "My euphoria kind of ended a few minutes ago, but I'm feeling kind of neutral.")
            ],
            "03/04/2023": [
                Entry(mood: "Good", text: "Had a great day today! Spent time with friends and enjoyed the beautiful weather."),
                Entry(mood: "Joy", text: "Feeling incredibly happy and grateful. Life is wonderful!"),
                Entry(mood: "Unhappy", text: "Feeling a bit down today. I had an argument with my sibling."),
            ],
            "10/04/2023": [
                Entry(mood: "Neutral", text: "Not feeling particularly happy or sad today. Just going through the day."),
                Entry(mood: "Sad", text: "Feeling a bit low. Missed an important deadline at work."),
                Entry(mood: "Joy", text: "Had an amazing surprise party thrown by my friends. Feeling ecstatic!")
            ],
            "18/05/2023": [
                Entry(mood: "Neutral", text: "Taking it easy today. Just relaxing and enjoying some quiet time."),
                Entry(mood: "Good", text: "Feeling content and satisfied with my achievements so far."),
                Entry(mood: "Sad", text: "Received some disappointing news today. It's been a tough day.")
            ],
            "22/05/2023": [
                Entry(mood: "Joy", text: "Celebrating a milestone achievement today. Feeling on top of the world!"),
                Entry(mood: "Happy", text: "Had a fun outing with friends. Lots of laughter and good times."),
                Entry(mood: "Sad", text: "Feeling a bit emotional. Reflecting on some past memories.")
            ],
            "07/06/2023": [
                Entry(mood: "Sad", text: "Feeling down today. Missing someone special."),
                Entry(mood: "Neutral", text: "Not much excitement today. Just going through the routine."),
                Entry(mood: "Good", text: "Had a productive day. Accomplished many tasks and goals.")
            ],
            "14/06/2023": [
                Entry(mood: "Neutral", text: "Feeling neither good nor bad. Just an average day."),
                Entry(mood: "Joy", text: "Attended a concert of my favourite band. Pure bliss and happiness!"),
                Entry(mood: "Unhappy", text: "Dealing with some personal challenges. It's been a tough day.")
            ],
            "01/07/2023": [
                Entry(mood: "Good", text: "Spent quality time with family. Feeling loved and grateful."),
                Entry(mood: "Neutral", text: "Just a regular day. Nothing extraordinary."),
                Entry(mood: "Happy", text: "Received a surprise gift from a dear friend. Feeling joyful!")
            ],
            "11/07/2023": [
                Entry(mood: "Neutral", text: "Feeling balanced and calm today. Finding peace in the little things."),
                Entry(mood: "Sad", text: "Received some bad news. Feeling a mix of sadness and confusion."),
                Entry(mood: "Unhappy", text: "Struggling with a difficult situation. It's been a challenging day.")
            ]
        ]
        
        // Write the fake data to UserDefaults
        return fakeData
    }
    
    func readEntries() -> [String: [Entry]] {
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data {
            if let array = try? PropertyListDecoder().decode([String: [Entry]].self, from: savedArrayData) {
                return array
            } else {
                return [:]
            }
        } else {
            return injectFakeData()
        }
    }
}
