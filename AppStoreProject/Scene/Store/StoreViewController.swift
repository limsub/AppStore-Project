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
    
    let viewModel = StoreViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bindInputOutput()
    }
    
    func bindInputOutput() {
        let input = StoreViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty,
            refreshControlValueChanged: refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input)
        
        // 테이블뷰 데이터 세팅
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
        
        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        
        output.refreshLoading
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
