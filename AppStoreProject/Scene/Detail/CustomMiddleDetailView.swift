//
//  CustomMiddleDetailView.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import UIKit


class CustomMiddleDetailView: BaseView {
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 22)
        view.text = "평가 및 리뷰"
        return view
    }()
    let ratingLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 56)
        view.text = "4.5"
        return view
    }()
    let maxLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        view.text = "(최고 5점)"
        return view
    }()
    
    let cntLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .lightGray
        view.text = "187,822개의 평가"
        return view
    }()
    
    let reviewButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        view.setTitle("  리뷰 작성", for: .normal)
        view.setTitleColor(UIColor(hexCode: UIColor.DownloadButtonColor.text.rawValue), for: .normal)
        view.tintColor = UIColor(hexCode: UIColor.DownloadButtonColor.text.rawValue)
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(titleLabel)
        addSubview(ratingLabel)
        addSubview(maxLabel)
        addSubview(cntLabel)
        addSubview(reviewButton)
        
    }
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalTo(titleLabel)
        }
        maxLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
            make.centerX.equalTo(titleLabel)
        }
        cntLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(self)
        }
        reviewButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    override func setting() {
        super.setting()
        
        
    }
    
    func designView(_ item: AppInfo) {
        let multiplier = pow(10.0, Double(1))
        ratingLabel.text = "\(round(item.averageUserRating * multiplier) / multiplier)"
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        cntLabel.text = "\(numberFormatter.string(from: NSNumber(value: item.userRatingCount))!) 개의 평가"
        
        
    }
}
