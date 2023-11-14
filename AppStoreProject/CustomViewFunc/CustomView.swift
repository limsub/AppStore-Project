//
//  CustomView.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import UIKit


class CustomView {
    static func makeIconImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(hexCode: UIColor.IconImageColor.border.rawValue).cgColor
        view.layer.borderWidth = 1
        return view
    }
    
    static func makeDownloadButton() -> UIButton {
        let view = UIButton()
        
        view.setTitle("받기", for: .normal)
        
        view.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
        view.setTitleColor(UIColor(hexCode: UIColor.DownloadButtonColor.text.rawValue), for: .normal)
        view.backgroundColor = UIColor(hexCode: UIColor.DownloadButtonColor.background.rawValue)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }
    
    static func makeSeperateLine() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
}
