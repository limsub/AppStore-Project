//
//  UIViewController+Extension.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/12.
//

import UIKit


extension UIViewController {
    
    func showSingleAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
    
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
