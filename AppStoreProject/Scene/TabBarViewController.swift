//
//  TabViewController.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let searchVC = SearchAppViewController()
    
    let homeVC = SearchAppViewController()
    
    let saveVC = StoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [searchVC, homeVC, saveVC].forEach { vc in
            vc.tabBarItem.image = UIImage(systemName: "pencil")
        }
        
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        let navHomeVC = UINavigationController(rootViewController: homeVC)
        let navSaveVC = UINavigationController(rootViewController: saveVC)
        
        let tabItem = [navSearchVC, navHomeVC, navSaveVC ]
        
        tabBar.backgroundColor = .lightGray
        
        viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
    
}
