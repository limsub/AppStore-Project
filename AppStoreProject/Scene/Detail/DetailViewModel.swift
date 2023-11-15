//
//  DetailViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/10.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class DetailViewModel: ViewModelType {
    
    var appInfo: AppInfo?
    
    let disposeBag = DisposeBag()
    
    let repository = ReviewRealmRepository()
    let storeRepository = RealmRepository()
    
    struct Input {
        let reviewButtonClicked: ControlEvent<Void>
        let downloadButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let reviewButtonClicked: ControlEvent<Void>
        let reviewItems: BehaviorSubject<[ReviewItemTable]>
        let isDownload: BehaviorSubject<Bool>
    }
    
    let realm = try! Realm()
//    var data: Result<AppItemTable>?
//    var notificationToken: NotificationToken?
    
    
    func transform(_ input: Input) -> Output {
    
        
        // 이미 다운로드되어있는지 렘에서 찾기
        let isDownload = BehaviorSubject(value: false)
        isDownload.onNext(storeRepository.checkDownload(AppItemTable(appInfo!)))
        
        // 다운로드 여부
        storeRepository.detectChange(AppItemTable(appInfo!)) { iCnt, dCnt in
            // 삭제되었다 -> deletions.count == 1
            if (dCnt == 1) {
                print("디테일뷰컨 : 삭제 감지")
                isDownload.onNext(false)
            }

            // 받았다 -> insertions.count == 1
            if (iCnt == 1) {
                print("디테일뷰컨 : 추가 감지")
                isDownload.onNext(true)
            }
        }
        
        // 다운로드 버튼 클릭하면 렘에 저장 or 삭제하고 isDownload 업데이트
        input.downloadButtonClicked
            .withLatestFrom(isDownload, resultSelector: { _, value in
                return value
            })
            .subscribe(with: self) { owner , value in
                // 이미 다운받았다 -> 삭제
                if value {
                    print("삭제합니당")
                    owner.storeRepository.deleteApp(item: AppItemTable(owner.appInfo!)
                    )
                    isDownload.onNext(false)
                }
                // 다운받지 않았다 -> 다운
                else {
                    print("다운받습니당")
                    owner.storeRepository.addApp(
                        owner.appInfo!.genres[0],
                        item: AppItemTable(owner.appInfo!)
                    )
                    isDownload.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
        // appInfo 기반으로 렘에서 리뷰 데이터 불러오기
        let reviewItems = BehaviorSubject<[ReviewItemTable]>(value: [])
        let items = repository.readReview(appInfo!.trackId)
        reviewItems.onNext(items)
        
        
        // 리뷰에 변동이 있는지 렘에서 체크
        repository.detectChangesInReview(appInfo!.trackId) { updateItems in
            reviewItems.onNext(updateItems)
        }
        
        
        
        return Output(
                reviewButtonClicked: input.reviewButtonClicked,
                reviewItems: reviewItems,
                isDownload: isDownload
        )
    }
    
}
