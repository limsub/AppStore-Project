//
//  SearchAppViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import Foundation
import RxSwift
import RxCocoa

class SearchAppViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    
    var offset = 0

    struct Input {
        let searchButtonClicked: ControlEvent<Void> // searchBar.rx.searchButtonClicked
        let searchText: ControlProperty<String> // searchBar.rx.text.orEmpty
        let tableViewReachedBottom: ControlEvent<Void> // tableView.rx.reachedBottom
        let tableViewItemSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<AppInfo>.Element)>
    }


    struct Output {
        let items: BehaviorSubject<[AppInfo]>
        let dataCnt: BehaviorSubject<Int>
        let tableViewItemSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<AppInfo>.Element)>
        let tableViewReachedBottom: ControlEvent<Void> // tableView.rx.reachedBottom
//        let nextData: PublishSubject<AppInfo>
       
    }


    func transform(_ input: Input) -> Output {
        
        let items = BehaviorSubject<[AppInfo]>(value: [])  // 테이블뷰에 보여줄 데이터
        let titleCnt = BehaviorSubject<Int>(value: 0) // 현재 데이터 개수
    
        // 검색어를 입력했을 때 -> 전체 변경
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText) { _, query in
                return query
            }
            .flatMap { BasicAPIManager.fetchInitialData($0) }
            .subscribe(with: self) { owner , value in
                items.onNext(value.results)
                titleCnt.onNext(value.resultCount)
                
                owner.offset = 0;
            }
            .disposed(by: disposeBag)
        
        
        
        // 페이지네이션이 일어날 때 -> 배열 뒤에 추가
        input.tableViewReachedBottom
            .withLatestFrom(input.searchText) { _, query in
                return query
            }
            .subscribe(with: self) { owner , value in
                owner.offset += 30;
                
                BasicAPIManager.appendData(value, offset: owner.offset) { response in
                    switch response {
                    case .success(let data):
                        var oldData = try! items.value()
                        oldData.append(contentsOf: data.results)
                        items.onNext(oldData)
                        
                        var oldCnt = try! titleCnt.value()
                        oldCnt += data.resultCount
                        titleCnt.onNext(oldCnt)
                        
                    case .failure(let error):
                        print("error : \(error)")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        


        return Output(
            items: items,
            dataCnt: titleCnt,
            tableViewItemSelected: input.tableViewItemSelected,
            tableViewReachedBottom: input.tableViewReachedBottom
        )
    }
    
    
    
    
}
