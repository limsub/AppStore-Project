//
//  DetailViewModel.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/10.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: ViewModelType {
    
    var appInfo: AppInfo?
    
    struct Input {
        let reviewButtonClicked: ControlEvent<Void>
    }
    struct Output {
        let reviewButtonClicked: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        
        
        
        
        
        
        return Output(
                    reviewButtonClicked: input.reviewButtonClicked
        )
    }
    
}
