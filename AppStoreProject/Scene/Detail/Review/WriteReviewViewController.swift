//
//  WriteReviewViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

class WriteReviewViewController: BaseViewController {
    
    let cancelButton = UIBarButtonItem(title: "취소")
    let sendButton = UIBarButtonItem(title: "보내기")
    
    let cosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.starSize = 30
        view.rating = 0
        view.settings.minTouchRating = 0.5
        return view
    }()
    let cosmosLabel = {
        let view = UILabel()
        view.text = "평가하려면 별표 탭하기"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let seperateLine = CustomView.makeSeperateLine()
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목"
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    let seperateLine2 = CustomView.makeSeperateLine()
    
    let contentTextView = {
        let view = UITextView()
        view.text = ""
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    
    
    let disposeBag = DisposeBag()
    
    let viewModel = WriteReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        bind()
    }
    override func setConfigure() {
        super.setConfigure()
        
        
        view.addSubview(cosmosView)
        view.addSubview(cosmosLabel)
        view.addSubview(seperateLine)
        view.addSubview(titleTextField)
        view.addSubview(seperateLine2)
        view.addSubview(contentTextView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        cosmosView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.centerX.equalTo(view)
        }
        cosmosLabel.snp.makeConstraints { make in
            make.top.equalTo(cosmosView.snp.bottom).offset(8)
            make.centerX.equalTo(view)
        }
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(cosmosLabel.snp.bottom).offset(4)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(4)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        seperateLine2.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view).inset(18)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(seperateLine2.snp.bottom).offset(4)
            make.bottom.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(14)
        }
        
    }
    
    func setNavigation() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendButton
        title = "리뷰 작성하기"
    }
    
    func bind() {
        
        let rate = BehaviorSubject(value: 0.0)
        cosmosView.rx.didFinishTouchingCosmos.onNext { value in
            rate.onNext(value)
        }
        
        let input = WriteReviewViewModel.Input(
                  rate: rate,
                  titleText: titleTextField.rx.text.orEmpty,
                  contentText: contentTextView.rx.text.orEmpty,
                  sendButtonClicked: sendButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.reviewValidation
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.sendButtonClicked
            .subscribe(with: self) { owner , _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
