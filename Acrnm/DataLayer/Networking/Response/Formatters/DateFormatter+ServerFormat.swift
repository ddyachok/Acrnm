//
//  DateFormatter+ServerFormat.swift
//  Hubmee
//
//  Created by Vasyl Khmil on 28.06.2023.
//

import Foundation

extension DateFormatter {
    static let serverDateAndTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        #warning("Specify your formatter and other you need here")
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return formatter
    }()
}
