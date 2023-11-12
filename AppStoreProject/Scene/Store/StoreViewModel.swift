//
//  StoreViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import Foundation
import RxSwift
import RxCocoa

class StoreViewModel: ViewModelType {
    
    let repository = RealmRepository()
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>     // searchBar.rx.text.orEmpty
        let refreshControlValueChanged: ControlEvent<Void>  // refreshControl.rx.controlEvent(.valueChanged)
    }
    struct Output {
        let items: BehaviorSubject<[GenreItems]>
        let refreshLoading: BehaviorSubject<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let items = BehaviorSubject<[GenreItems]>(value: [])
        let refreshLoading = BehaviorSubject<Bool>(value: false)
        
        // 검색 문자열에 따라 items 변경. 빈 문자열인 경우, 모든 데이터 넘겨줌
        input.searchText
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print("실시간 검색 : \(value)")
                
                let newData = (value == "") ? owner.repository.allGenresApp() : owner.repository.searchGenresApp(value)
                items.onNext(newData)
            }
            .disposed(by: disposeBag)
        
        // 새로고침 -> 1초 로딩
        input.refreshControlValueChanged
            .withLatestFrom(input.searchText) { _, text in
                return text
            }
            .subscribe(with: self) { owner , text in
                print("새로고침 : \(text)")
                refreshLoading.onNext(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let newData = (text == "") ? owner.repository.allGenresApp() : owner.repository.searchGenresApp(text)
                    items.onNext(newData)
                    
                    refreshLoading.onNext(false)
                }
            }
            .disposed(by: disposeBag)
            
        
        
        return Output(
            items: items,
            refreshLoading: refreshLoading
        )
    }
}
