//
//  PagingViewControllerExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Parchment
import NSObject_Rx
import SWFrame

extension Reactive where Base: PagingViewController {

    var reloadData: Binder<Void> {
        return Binder(self.base) { paging, _ in
            paging.reloadData()
        }
    }

    var indicatorColor: Binder<UIColor> {
        return Binder(self.base) { paging, color in
            paging.indicatorColor = color
        }
    }
    
    var textColor: Binder<UIColor> {
        return Binder(self.base) { paging, color in
            paging.textColor = color
        }
    }
    
    var selectedTextColor: Binder<UIColor> {
        return Binder(self.base) { paging, color in
            paging.selectedTextColor = color
        }
    }

}
