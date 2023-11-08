//
//  GenreItemStruct.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


struct GenreItems {
    var name: String
    var items: [Item]
}

extension GenreItems: SectionModelType {
    typealias Item = AppInfo
    
    init(original: GenreItems, items: [Item]) {
        self = original
        self.items = items
    }
}
