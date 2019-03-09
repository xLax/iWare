//
//  Utils.swift
//  iWare
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//
import Foundation
import UIKit

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
    
    static func addSpinnerToView(viewController: UIViewController) -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        let loadingView = SpinnerView(frame: CGRect(x: screenSize.width/2 - 50, y: screenSize.height/2 - 50, width: 100, height: 100))
        viewController.view.addSubview(loadingView)
        
        return loadingView
    }
}
