//
//  StoreViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class StoreViewController: BaseViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = {
        let view = UITableView()
        view.register(SearchAppTableViewCell.self , forCellReuseIdentifier: "StoreCell")
        view.rowHeight = 120
        view.separatorStyle = .singleLine
        view.refreshControl = refreshControl
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    
    let disposeBag = DisposeBag()
    
    let repository = RealmRepository()
    
    let refreshLoading = BehaviorRelay(value: false)
    
    let a = BehaviorSubject<[GenreItems]>(value: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = repository.allGenresApp()
        
        let dataSource = RxTableViewSectionedReloadDataSource<GenreItems> { dataSource, tableView, indexPath , item  in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as? SearchAppTableViewCell else { return UITableViewCell() }
    
            cell.designCell(item, isDownloadedFirst: false)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            // 데이터가 없는 섹션은 아예 헤더도 없애버림
            if dataSource.sectionModels[index].items.isEmpty { return nil }
        
            return dataSource.sectionModels[index].name
        }
        
        
        
//        Observable.just(data)
        
        a.onNext(data)
        a
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        bind()
        refreshBind()
    }
    
    func bind() {
        
        searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value  in
                print("===실시간 검색===\(value)")
                
                // 빈 문자열이면 저장된 모든 데이터를 보여주자
                let newData = (value == "") ? owner.repository.allGenresApp() : owner.repository.searchGenresApp(value)
                owner.a.onNext(newData)
            }
            .disposed(by: disposeBag)
    }
    
    func refreshBind() {
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty, resultSelector: { _, text in
                return text
            })
            .bind(with: self , onNext: { owner , text in
                print("refresh value change")
                owner.refreshLoading.accept(true)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    owner.refreshLoading.accept(false)
                    
                    print("===땡겨서 실시간 검색===\(text)")
                    
                    // 빈 문자열이면 저장된 모든 데이터를 보여주자
                    let newData = (text == "") ? owner.repository.allGenresApp() : owner.repository.searchGenresApp(text)
                    owner.a.onNext(newData)
                }
            })
            .disposed(by: disposeBag)
            
        
        refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
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
