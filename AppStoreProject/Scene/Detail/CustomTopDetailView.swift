//
//  CustomTopDetailView.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import UIKit
import Kingfisher

class CustomTopDetailView: BaseView {
    
    let iconImageView = CustomView.makeIconImageView()
    
    let nameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.numberOfLines = 2
        return view
    }()
    
    let sellerNameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .lightGray
        return view
    }()
    
    let downloadButton = CustomView.makeDownloadButton()
    
    let shareButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(sellerNameLabel)
        addSubview(downloadButton)
        addSubview(shareButton)
    }
    override func setConstraints() {
        super.setConstraints()
        
        iconImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self)
            make.width.equalTo(iconImageView.snp.height)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self)
        }
        sellerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.trailing.equalTo(self)
        }
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalTo(self)
        }
        shareButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self)
            make.size.equalTo(30)
        }
    }
    override func setting() {
        super.setting()
        
    }
    
    
    func designView(_ item: AppInfo) {
        iconImageView.kf.setImage(with: URL(string: item.artworkUrl512))
        
        nameLabel.text = item.trackName
        
        sellerNameLabel.text = item.sellerName
        
        
        
    }
}
