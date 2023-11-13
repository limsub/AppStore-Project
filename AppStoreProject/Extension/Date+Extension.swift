//
//  Date.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/13.
//

import Foundation

extension Date {
    func toString(of type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}


enum DateFormatType: String {
    case koreanText = "M월 dd일"
}
