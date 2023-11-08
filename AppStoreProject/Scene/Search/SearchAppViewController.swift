//
//  SearchAppViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class SearchAppViewController: BaseViewController {
    
    private let tableView = {
        let view = UITableView()
        view.register(SearchAppTableViewCell.self , forCellReuseIdentifier: SearchAppTableViewCell.description())
        view.rowHeight = 120
        view.separatorStyle = .singleLine
        view.backgroundColor = .red
        return view
    }()
    
//    let searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var data: [AppInfo] = []
//    var data = ["a", "b", "c", "d", "e"]
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bind()
    }
    
    func bind() {
        
        // cellForRowAt
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchAppTableViewCell.description(), cellType: SearchAppTableViewCell.self)) { (row, element, cell) in
                
                cell.designCell(element)
            }
            .disposed(by: disposeBag)
        
        // 네트워크 콜
//        let request = BasicAPIManager.fetchData("todo")
//            .asDriver(onErrorJustReturn: SearchAppModel(resultCount: 0, results: []))
//        // drive : 여러 곳에 연결해줄 때, share 기능을 활용할 수 있는 장점
//        request
//            .drive(with: self) { owner , value in
//                owner.items.onNext(value.results)
//            }
//            .disposed(by: disposeBag)
//
//        request
//            .map { value in
//                "\(value.resultCount)개의 검색 결과"
//            }
//            .drive(navigationItem.rx.title)
//            .disposed(by: disposeBag)
        
        let request = searchController.searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty) { _, query in
                return query
            }
            .flatMap { BasicAPIManager.fetchData($0) }
            .asDriver(onErrorJustReturn: SearchAppModel(resultCount: 0, results: []))
        // 여러 곳에 연결할 때, share 기능을 활용할 수 있도록 drive로 바꿔주었다.
        // 기존 타입은 complete, error 이벤트가 발생할 수 있는 Observable이었기 때문에 onErrorJustReturn 으로 예외처리 해준다
        
        request
            .drive(with: self) { owner , value in
                owner.items.onNext(value.results)
            }
            .disposed(by: disposeBag)
        
        request
            .map { value in
                "\(value.resultCount)개의 검색 결과"
            }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(tableView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setting() {
        super.setting()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    
    
}
