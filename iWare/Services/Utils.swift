//
//  Utils.swift
//  iWare
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//
import Foundation

class Utils {
    
    static func getUniqeId() -> String {
        return NSUUID().uuidString
    }
    
    static func getDateFromString(dateStr: String) -> Date
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponentArray = dateStr.components(separatedBy: "/")
        
        var components = DateComponents()
        components.year = Int(dateComponentArray[2])
        components.month = Int(dateComponentArray[1])
        components.day = Int(dateComponentArray[0])
        components.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = calendar.date(from: components)
        
        return (date!)
    }
    
    static func getStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    static func findKeyForValue(value: String, dictionary: [Int: String]) -> Int?
    {
        for (key, array) in dictionary {
            if (array.contains(value))
            {
                return key
            }
        }
        
        return nil
    }
}
