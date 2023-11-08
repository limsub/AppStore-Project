//
//  RealmModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import Foundation
import RealmSwift

class AppGenreTable: Object {
    @Persisted(primaryKey: true) var genreName: String
    @Persisted var appItems: List<AppItemTable> = List<AppItemTable>()
    
    convenience init(_ genreName: String) {
        self.init()
        
        self.genreName = genreName
    }
}

class AppItemTable: Object {
    
    @Persisted(primaryKey: true) var trackId: Int
    
    @Persisted var screenshotUrls: List<String> = List<String>()
    @Persisted var trackName: String // 이름
    @Persisted var genres: List<String> = List<String>() // 장르
    @Persisted var trackContentRating: String // 연령제한
    @Persisted var appDescription: String // 설명
    @Persisted var price: Double // 가격
    @Persisted var sellerName: String // 개발자 이름
    @Persisted var formattedPrice: String // 가격(무료/유료)
    @Persisted var userRatingCount: Int // 평가자 수
    @Persisted var averageUserRating: Double // 평균 평점
    @Persisted var artworkUrl512: String // 아이콘 이미지
    @Persisted var languageCodesISO2A: List<String> = List<String>() // 언어 지원
    @Persisted var version: String
    @Persisted var releaseNotes: String
    
    convenience init(_ app: AppInfo) {
        self.init()
        
    
        self.trackId = app.trackId
        
        
        app.screenshotUrls.forEach { item in
            self.screenshotUrls.append(item)
        }
        app.genres.forEach { item in
            self.genres.append(item)
        }
        app.languageCodesISO2A.forEach { item in
            self.languageCodesISO2A.append(item)
        }
        
        self.trackName = app.trackName
        self.trackContentRating = app.trackContentRating
        self.appDescription = app.description
        self.price = app.price
        self.sellerName = app.sellerName
        self.formattedPrice = app.formattedPrice
        self.userRatingCount = app.userRatingCount
        self.averageUserRating = app.averageUserRating
        self.artworkUrl512 = app.artworkUrl512
        self.version = app.version
        self.releaseNotes = app.releaseNotes
    }
}
