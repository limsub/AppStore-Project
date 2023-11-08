//
//  RealmRepository.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import Foundation
import RealmSwift

class RealmRepository {
    
    let realm = try! Realm()
    
    // 받기 눌러서 데이터 추가
    // 1. 해당 장르 테이블이 있으면 거기다 추가
    // 2. 해당 장르 테이블이 없으면 장르 테이블 만들고, 거기다 추가
    
    func addApp(_ genreName: String, item: AppItemTable) {
        
        print("trackId : \(item.trackId)")
        
        // 장르 테이블이 있는지 확인
        let data = realm.objects(AppGenreTable.self).where {
            $0.genreName == genreName
        }
        
        if data.isEmpty {
            print("기존에 없던 장르입니다. 새롭게 장르 테이블 생성")
            // 새로운 장르 테이블 생성 후 거기에 아이템 추가
            let newGenreTable = AppGenreTable(genreName)
            do {
                try realm.write {
                    newGenreTable.appItems.append(item)
                    realm.add(newGenreTable)
                }
            } catch {
                print("에러")
            }
        } else {
            print("기존에 있는 장르입니다. 기존 장르 테이블에 추가")
            do {
                try realm.write {
                    data[0].appItems.append(item)
                }
            } catch {
                print("에러")
            }
        }
    }
    
    func printURL() {
        print(realm.configuration.fileURL!)
    }
}
