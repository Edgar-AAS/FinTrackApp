//
//  DateFormatter.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 25/02/25.
//

import Foundation

final class FormatDate {
    static func format(fromFormat: String, toFormat: String, dateString: String) -> String? {
        let fromDateFomatter = DateFormatter()
        fromDateFomatter.dateFormat = fromFormat
        
        let toDateFormmater = DateFormatter()
        toDateFormmater.dateFormat = toFormat
        toDateFormmater.locale = Locale(identifier: "pt-BR")
        
        if let date = fromDateFomatter.date(from: dateString) {
            return toDateFormmater.string(from: date)
        }
        return nil
    }
}
