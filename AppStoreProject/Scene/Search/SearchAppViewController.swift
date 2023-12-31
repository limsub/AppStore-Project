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
        return view
    }()
    
    let activityIndicator = {
        let view = UIActivityIndicatorView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.hidesWhenStopped = true
        return view
    }()
    
//    let searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    
    var offset = 0;
    
    var searchText = ""
    var resultCnt = BehaviorSubject(value: 0)
    
    var data: [AppInfo] = []
//    var data = ["a", "b", "c", "d", "e"]
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    let repository = RealmRepository()
    
    let viewModel = SearchAppViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        repository.printURL()
        
//        bind()
        bindInputOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func bindInputOutput() {
        
        let input = SearchAppViewModel.Input(
            searchButtonClicked: searchController.searchBar.rx.searchButtonClicked,
            searchText: searchController.searchBar.rx.text.orEmpty,
            tableViewReachedBottom: tableView.rx.reachedBottom(),
            tableViewItemSelected: Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AppInfo.self))
            )
        
        let output = viewModel.transform(input)
        
        // 테이블뷰 데이터 구성
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: SearchAppTableViewCell.description(), cellType: SearchAppTableViewCell.self )) { (row, element, cell) in
                
                self.activityIndicator.stopAnimating()
                
                let isDownloadedFirst = self.repository.checkDownload(AppItemTable(element))
                cell.designCell(element, isDownloadedFirst: isDownloadedFirst)
                
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner , _ in
                        
                        // 렘에 저장된 데이터인지 여부 체크
                        let isDownloaded = owner.repository.checkDownload(AppItemTable(element))
                        
                        if !isDownloaded {
                            print("추가함")
                            owner.repository.addApp(element.genres[0], item: AppItemTable(element))
                        } else {
                            print("삭제함")
                            owner.repository.deleteApp(item: AppItemTable(element))
                        }
                        
                        // 추가 또는 삭제가 완료되었으면 UI 업데이트
                        cell.downloadButton.setTitle(isDownloaded ? "받기" : "삭제", for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        // 네비게이션 타이틀 구성
        output.dataCnt
            .map { "검색 결과 : \($0) 개" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        
        // 바닥 도착해서 페이지네이션
        output.tableViewReachedBottom
            .bind(with: self) { owner , _   in
                owner.activityIndicator.startAnimating()
//                owner.activityIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
        

        // 아이템 선택해서 화면 전환
        output.tableViewItemSelected
            .subscribe(with: self) { owner , data in
                let vc = DetailViewController()
                vc.viewModel.appInfo = data.1
                
                owner.navigationController?.pushViewController(vc, animated: true)
                owner.tableView.deselectRow(at: data.0, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setting() {
        super.setting()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "검색", style: .plain, target: self, action: nil)
        
    }

}


/*
extension SearchAppViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        print(currentOffset - maximumOffset)
        
        if currentOffset > maximumOffset {
            activityIndicator.startAnimating()
            
            offset += 30
            
            BasicAPIManager.appendData(searchText, offset: offset) { response in
                switch response {
                case .success(let data):
                    var oldData = try! self.items.value()
                    oldData.append(contentsOf: data.results)
                    self.items.onNext(oldData)
                    
                    var oldCnt = try! self.resultCnt.value()
                    oldCnt += data.resultCount
                    self.resultCnt.onNext(oldCnt)
                    
                    
                case .failure(let error):
                    print("error : \(error)")
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
            }
            
            
        }
    }
}
*/
