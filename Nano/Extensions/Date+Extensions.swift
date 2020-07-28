//
//  Date+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation

extension Date
{
    func timeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        if components.day! >= 365 {
            return "\(components.day! / 365)y"
        }
        
        if components.day! >= 7 {
            return "\(components.day! / 7)w"
        }
        
        if components.day! > 0 {
            return "\(components.day!)d"
        }
        else if components.hour! > 0 {
            return "\(components.hour!)h"
        }
        else if components.minute! > 0 {
            return "\(components.minute!)m"
        }
        return "Now"
    }
    
    func fullTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        if components.day! >= 365 {
            if components.day! / 365 < 2 {
                return "1 year ago"
            }
            return "\(components.day! / 365) years ago"
        }
        
        if components.day! >= 7 {
            if components.day! / 7 < 2 {
                return "1 week ago"
            }
            return "\(components.day! / 7) weeks ago"
        }
        
        if components.day! > 0 {
            if components.day! == 1 {
                return "1 day ago"
            }
            return "\(components.day!) days ago"
        }
        else if components.hour! > 0 {
            if components.hour! == 1 {
                return "1 hour ago"
            }
            return "\(components.hour!) hours ago"
        }
        else if components.minute! > 0 {
            if components.minute! == 1 {
                return "1 minute ago"
            }
            return "\(components.minute!) minutes ago"
        }
        return "Now"
    }
    
    func timeSinceNowWithAgo() -> String
    {
        let timeStr = timeSinceNow()
        if timeStr == "Now" {
            return timeStr
        }
        
        return "\(timeStr) ago"
    }
    

}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EDT")
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}
