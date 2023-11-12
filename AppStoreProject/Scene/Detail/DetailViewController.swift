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
    
    let viewModel = DetailViewModel()

    let topView = CustomTopDetailView()
    let seperateLine = CustomView.makeSeperateLine()
    let middleView = CustomMiddleDetailView()
    let seperateLine2 = CustomView.makeSeperateLine()
    
    
    
    let cosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.starSize = 50
        view.rating = 0
        view.settings.minTouchRating = 0.5
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        topView.designView(viewModel.appInfo!)
        middleView.designView(viewModel.appInfo!)
    }
    
    func bind() {
        
        let input = DetailViewModel.Input(
            reviewButtonClicked: middleView.reviewButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.reviewButtonClicked
            .subscribe(with: self) { owner , _ in
                print("버튼 클릭드")
                let nav = UINavigationController(rootViewController: WriteReviewViewController())
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        

        cosmosView.rx.didFinishTouchingCosmos.onNext { value in
            print(value)
        }
    }
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(topView)
        view.addSubview(seperateLine)
        view.addSubview(middleView)
        view.addSubview(seperateLine2)
        
        
        view.addSubview(cosmosView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(120)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(18)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        middleView.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(18)
            make.height.equalTo(120)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        seperateLine2.snp.makeConstraints { make in
            make.top.equalTo(middleView.snp.bottom).offset(18)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        
        cosmosView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    override func setting() {
        super.setting()
        
        
    }
}



