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
    
    let tableView = {
        let view = UITableView()
        view.register(SearchAppTableViewCell.self , forCellReuseIdentifier: "StoreCell")
        view.rowHeight = 120
        view.separatorStyle = .singleLine
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let repository = RealmRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = repository.allGenresApp()
        
        let dataSource = RxTableViewSectionedReloadDataSource<GenreItems> { dataSource, tableView, indexPath , item  in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as? SearchAppTableViewCell else { return UITableViewCell() }
    
            cell.designCell(item)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        
        Observable.just(data)
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
}
