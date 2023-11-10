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
        return ControlEvent(events: source)
      }
    
}
