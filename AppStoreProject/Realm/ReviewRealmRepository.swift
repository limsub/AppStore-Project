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
    func addReview(_ trackId: Int, review: ReviewItemTable) {
        
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
}
