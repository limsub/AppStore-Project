//
//  ReviewRealmRepository.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/13.
//

import Foundation
import RealmSwift

class ReviewRealmRepository {
    
    let realm = try! Realm()
    
    
    // (C) 1. 앱에 대한 리뷰 등록
    func createReview(_ trackId: Int, review: ReviewItemTable) {
        
        // 렘에 이미 있는 앱인지 확인
        let data = realm.objects(AppReviewTable.self).where {
            $0.trackId == trackId
        }
        
        
        // 렘에 이미 있는 앱이면 배열에 리뷰 추가
        if !data.isEmpty {
            print("기존에 리뷰가 있는 앱입니다. 리뷰 배열에 추가")
            do {
                try realm.write {
                    data[0].appReviews.append(review)
                }
            } catch {
                print("에러")
            }
        }
        // 렘에 없는 앱이면 렘 테이블도 만들고, 배열에 리뷰 추가
        else {
            print("기존에 리뷰가 없는 앱입니다. 앱 테이블도 새로 생성합니다")
            let newAppReviewTable = AppReviewTable(trackId)
            do {
                try realm.write {
                    newAppReviewTable.appReviews.append(review)
                    realm.add(newAppReviewTable)
                }
            } catch {
                print("에러")
            }
        }
        
    }
    
    // (R) 2. 앱에 대한 리뷰 불러오기
    func readReview(_ trackId: Int) -> [ReviewItemTable] {
        let app = realm.objects(AppReviewTable.self).where {
            $0.trackId == trackId
        }
        if app.isEmpty { return [] }
        
        if app[0].appReviews.isEmpty { return [] }
        
        return Array(app[0].appReviews)
    }
    
    
    // Realm Notification
    var notificationToken: NotificationToken?

    func detectChangesInReview(_ trackId: Int, completionHandler: @escaping ([ReviewItemTable]) -> Void) {
        
        let data = realm.objects(AppReviewTable.self).where {
            $0.trackId == trackId
        }
        
        notificationToken = data.observe { changes in
            switch changes {
            case .initial(let data):
                print("initial : \(data)")
                
            case .update(let data, _, _, _):
                print("update : \(data)")
                completionHandler(Array(data[0].appReviews))
                
            case .error(let error):
                print("error : \(error)")
                
            }
        }
    }
}
