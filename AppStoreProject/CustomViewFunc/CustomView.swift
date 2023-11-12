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
        view.layer.cornerRadius = 10
        return view
    }
    
    static func makeDownloadButton() -> UIButton {
        let view = UIButton()
        view.setTitle("받기", for: .normal)
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }
    
    static func makeSeperateLine() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
}
