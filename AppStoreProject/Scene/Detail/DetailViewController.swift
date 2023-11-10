//
//  DetailViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Cosmos



class DetailViewController: BaseViewController {
    
    let mainLabel = UILabel()
    
    let cosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.starSize = 50
        view.rating = 0
        view.settings.minTouchRating = 0.5
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
//        cosmosView.didFinishTouchingCosmos = { rating in
//            print("===", rating)
//        }
        
        
        mainLabel.text = viewModel.appInfo?.trackName
        
        
        cosmosView.rx.didFinishTouchingCosmos.onNext { value in
            print(value)
        }
        
        
        
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(mainLabel)
        
        view.addSubview(cosmosView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        cosmosView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    override func setting() {
        super.setting()
        
        
    }
}



