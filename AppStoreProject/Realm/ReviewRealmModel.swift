//
//  ReviewRealmModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/13.
//

import Foundation
import RealmSwift


class AppReviewTable: Object {
    @Persisted(primaryKey: true) var trackId: Int
    @Persisted var appReviews: List<ReviewItemTable> = List<ReviewItemTable>()
    
    convenience init(_ trackId: Int) {
        self.init()
        
        self.trackId = trackId
    }
}


class ReviewItemTable: Object {
    
    @Persisted(primaryKey: true) var _id:ObjectId
    
    @Persisted var title: String
    @Persisted var rate: Double
    @Persisted var content: String
    @Persisted var date: String
    
    convenience init(title: String, rate: Double, content: String, date: String) {
        self.init()
        
        self.title = title
        self.rate = rate
        self.content = content
        self.date = date
    }
}

