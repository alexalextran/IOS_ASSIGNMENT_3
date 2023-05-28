//
//  DateFunctions.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 28/5/2023.
//

import UIKit
class DateFunctions

{
    
    
    func updateCurrentMonthAndYearLabel(i:Int) -> String{ //return date using i as the month
        guard (1...12).contains(i) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Set the date format to display the full month name and year
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonthComponents = DateComponents(year: currentYear, month: i)
        
        guard let currentMonthDate = calendar.date(from: currentMonthComponents) else {
            print("Invalid current month date.")
            return ""
        }
        return dateFormatter.string(from: currentMonthDate)
    }
    
    
    func getCurrentMonth() -> Int { //gets the current month and returns it as a number to set i
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let currentMonth = dateFormatter.string(from: Date())
        return Int(currentMonth) ?? 0
    }
    
    func getCurrentDate() -> String{
        let dateShortFormatter = DateFormatter()  //set current date e.g 04/03/2023
        let today = Date()
        dateShortFormatter.dateFormat = "dd/MM/yyyy"
        return dateShortFormatter.string(from: today)
    }
    
    
}
