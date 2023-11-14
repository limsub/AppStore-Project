//
//  TabViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let searchVC = SearchAppViewController()
    
    let storeVC = StoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [searchVC, storeVC].forEach { vc in
            vc.tabBarItem.image = UIImage(systemName: "pencil")
        }
        
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        let navStoreVC = UINavigationController(rootViewController: storeVC)
        
        let tabItem = [navSearchVC, navStoreVC ]
        
        tabBar.backgroundColor = .lightGray
        
        viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
    
}
