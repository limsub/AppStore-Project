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
    
    
    // 삭제 눌러서 데이터 삭제 (반드시 데이터가 있는 걸 확인하고 실행하기. 인덱스 에러 날 가능성 있음)
    func deleteApp(item: AppItemTable) {
        // 1. 렘에서 해당 데이터를 찾는다
        // 2. 삭제
        
        let data = realm.objects(AppItemTable.self).where {
            $0.trackId == item.trackId
        }[0]
        
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("에러")
        }
    }
    

    // 기존에 추가했던 앱인지 확인 -> Bool 리턴
    func checkDownload(_ item: AppItemTable) -> Bool {
        let data = realm.objects(AppItemTable.self).where {
            $0.trackId == item.trackId
        }
        return !data.isEmpty
    }
    
    func printURL() {
        print(realm.configuration.fileURL!)
    }
}
