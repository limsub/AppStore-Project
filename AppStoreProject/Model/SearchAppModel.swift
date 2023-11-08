//
//  SearchAppModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import Foundation

struct SearchAppModel: Codable {
    let resultCount: Int
    let results: [AppInfo]
}

struct AppInfo: Codable {
    let screenshotUrls: [String]
    let trackName: String // 이름
    let genres: [String] // 장르
    let trackContentRating: String // 연령제한
    let description: String // 설명
    let price: Double // 가격
    let sellerName: String // 개발자 이름
    let formattedPrice: String // 가격(무료/유료)
    let userRatingCount: Int // 평가자 수
    let averageUserRating: Double // 평균 평점
    let artworkUrl512: String // 아이콘 이미지
    let languageCodesISO2A: [String] // 언어 지원
    let trackId: Int
    let version: String
    let releaseNotes: String
}

extension AppInfo {
    init(_ app: AppItemTable) {
        self.screenshotUrls = Array(app.screenshotUrls)
        self.trackName = app.trackName
        self.genres = Array(app.genres)
        self.trackContentRating = app.trackContentRating
        self.description = app.appDescription
        self.price = app.price
        self.sellerName = app.sellerName
        self.formattedPrice = app.formattedPrice
        self.userRatingCount = app.userRatingCount
        self.averageUserRating = app.averageUserRating
        self.artworkUrl512 = app.artworkUrl512
        self.languageCodesISO2A = Array(app.languageCodesISO2A)
        self.trackId = app.trackId
        self.version = app.version
        self.releaseNotes = app.releaseNotes
    }
}
