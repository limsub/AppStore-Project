//
//  WriteReviewViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa


class WriteReviewViewModel: ViewModelType {
    
    var appInfo: AppInfo?
    
    let disposeBag = DisposeBag()
    
    let repository = ReviewRealmRepository()
    
    struct Input {
        let rate: BehaviorSubject<Double>
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let sendButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let sendButtonClicked: ControlEvent<Void>
        let reviewValidation: BehaviorSubject<Bool>
    }
    
    
    func transform(_ input: Input) -> Output {
        
        let reviewValidation = BehaviorSubject(value: false)
        
        // 1. 입력이 되었는지 확인 후 validation 값 변경
        Observable.combineLatest(input.rate, input.titleText, input.contentText) {
            return ($0 > 0.0 && $0 < 5.0) && (!$1.isEmpty) && (!$2.isEmpty)
        }
        .subscribe(with: self) { owner , value in
            print("validation : \(value)")
            reviewValidation.onNext(value)
        }
        .disposed(by: disposeBag)
        
        
        
        // 2. sendButton이 눌리면 validation 확인 후 Realm에 올려줌
        let newItemObservable = Observable.combineLatest(input.rate, input.titleText, input.contentText) {
            return ReviewItemTable(title: $1, rate: $0, content: $2, date: Date().toString(of: .koreanText))
        }
  
        
        input.sendButtonClicked
            .withLatestFrom(reviewValidation) { _, value  in
                return value
            }
            .withLatestFrom(newItemObservable) { value, item in
                return (value, item)
            }
            .subscribe(with: self) { owner , tuple in
                if tuple.0 {
                    owner.repository.addReview(
                        owner.appInfo!.trackId,
                        review: tuple.1
                    )
                }
            }
            .disposed(by: disposeBag)
        
    
        
        return Output(
            sendButtonClicked: input.sendButtonClicked,
            reviewValidation: reviewValidation
        )
    }
}
