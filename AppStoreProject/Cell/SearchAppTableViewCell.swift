//
//  SearchAppTableViewCell.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SearchAppTableViewCell: BaseTableViewCell {
    
    let iconImageView = CustomView.makeIconImageView()
    
    let nameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let descriptionLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .lightGray
        return view
    }()
    
    let downloadButton = CustomView.makeDownloadButton()
    
    
    var disposeBag = DisposeBag()
    
    let repository = RealmRepository()
    
    override func setConfigure() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(downloadButton)
        
    }
    
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(12)
            make.size.equalTo(60)
        }
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(12)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.top.equalTo(iconImageView).inset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-12)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
    }
    
    override func setting() {
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func designCell(_ sender: AppInfo, isDownloadedFirst: Bool) {
        
        nameLabel.text = sender.trackName
        descriptionLabel.text = sender.description
        iconImageView.kf.setImage(with: URL(string: sender.artworkUrl512))
        
        downloadButton.setTitle(isDownloadedFirst ? "삭제" : "받기" , for: .normal)
    }
    
    
}
