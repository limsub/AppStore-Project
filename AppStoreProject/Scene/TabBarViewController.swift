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
        
        
        
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        storeVC.tabBarItem.image = UIImage(systemName: "square.stack.3d.up.fill")
        
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        let navStoreVC = UINavigationController(rootViewController: storeVC)
        
        let tabItem = [navSearchVC, navStoreVC ]
        
        tabBar.backgroundColor = .lightGray
        
        viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
    
}
