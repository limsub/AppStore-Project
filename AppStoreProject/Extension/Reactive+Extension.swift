//
//  Reactive+Extension.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/10.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    func reachedBottom(from space: CGFloat = 0.0) -> ControlEvent<Void> {
        
        let source = contentOffset.map { contentOffset in
          let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
          let y = contentOffset.y + self.base.contentInset.top
          let threshold = self.base.contentSize.height - visibleHeight - space
          return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        
//        let source2 = contentOffset.map { contentOffset in
//            return (self.base.frame.height - contentOffset.y < 700)
//
////                self.contentSize.height - contentOffset.y < 700)
//        }
//        .distinctUntilChanged()
//        .filter { $0 }
//        .map { _ in () }
        
        
        return ControlEvent(events: source)
      }
}
