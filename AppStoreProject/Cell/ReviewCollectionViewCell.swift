//
//  ReviewCollectionViewCell.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/13.
//

import UIKit
import Cosmos
import SnapKit
import RxSwift
import RxCocoa

class ReviewCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "아아아아아아아아아"
        return view
    }()
    let dateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textColor = .lightGray
        view.text = "4월 2일"
        view.textAlignment = .right
        return view
    }()
    let cosmosView = {
        let view = CosmosView()
        view.rating = 4.0
        view.isUserInteractionEnabled = false
        view.settings.starSize = 15
        return view
    }()
    let contentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.numberOfLines = 7
        view.text = "아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아아아아아앙아아아아아"
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(cosmosView)
        contentView.addSubview(contentLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.top.equalTo(contentView).inset(16)
            make.width.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).inset(16)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-4)
        }
        cosmosView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(cosmosView.snp.bottom).offset(4)
            make.trailing.equalTo(contentView).inset(12)
//            make.trailing.bottom.equalTo(contentView).inset(12)
        }
    }
    override func setting() {
        super.setting()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.backgroundColor = .systemGray6
    }
    
    func designCell(_ item: ReviewItemTable) {
        titleLabel.text = item.title
        dateLabel.text = item.date
        cosmosView.rating = item.rate
        contentLabel.text = item.content
        
    }
    
    
}
