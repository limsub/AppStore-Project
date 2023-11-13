//
//  DetailViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/10.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: ViewModelType {
    
    var appInfo: AppInfo?
    
    let disposeBag = DisposeBag()
    
    let repository = ReviewRealmRepository()
    
    struct Input {
        let reviewButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let reviewButtonClicked: ControlEvent<Void>
        
        let reviewItems: BehaviorSubject<[ReviewItemTable]>
    }
    
    func transform(_ input: Input) -> Output {
        // appInfo 기반으로 렘에서 데이터 불러오기
        let reviewItems = BehaviorSubject<[ReviewItemTable]>(value: [])
        let items = repository.readReview(appInfo!.trackId)
        reviewItems.onNext(items)
        
        
        return Output(
                reviewButtonClicked: input.reviewButtonClicked,
                reviewItems: reviewItems
        )
    }
    
}
