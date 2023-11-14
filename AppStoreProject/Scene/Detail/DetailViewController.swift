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
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createReviewLayout())
        view.register(ReviewCollectionViewCell.self , forCellWithReuseIdentifier: ReviewCollectionViewCell.description())
        
        return view
    }()
    
    func createReviewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 36
        
        layout.itemSize = CGSize(width: width, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        layout.scrollDirection = .horizontal
        
        
        return layout
    }
        
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        topView.designView(viewModel.appInfo!)
        middleView.designView(viewModel.appInfo!)
        
        
        
    }
    
    func bind() {
        
        let input = DetailViewModel.Input(
            reviewButtonClicked: middleView.reviewButton.rx.tap,
            downloadButtonClicked: topView.downloadButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.reviewButtonClicked
            .subscribe(with: self) { owner , _ in
                print("버튼 클릭드")
                let vc = WriteReviewViewController()
                vc.viewModel.appInfo = owner.viewModel.appInfo
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        output.reviewItems
            .bind(to: collectionView.rx.items(cellIdentifier: ReviewCollectionViewCell.description(), cellType: ReviewCollectionViewCell.self)) { (index, element, cell) in
                
                cell.designCell(element)
                
                print(index, element, cell)
            }
            .disposed(by: disposeBag)
        
        
        output.isDownload
            .subscribe(with: self) { owner , value in
                print("버튼 타이틀 변경")
                owner.topView.downloadButton.setTitle(
                    (value) ? "삭제" : "받기",
                    for: .normal
                )
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(topView)
        view.addSubview(seperateLine)
        view.addSubview(middleView)
        view.addSubview(seperateLine2)
        view.addSubview(collectionView)
        
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(seperateLine2.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(200)
        }
        
    }
    override func setting() {
        super.setting()
        
        
    }
}



