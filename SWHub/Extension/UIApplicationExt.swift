//
//  UIApplicationExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

extension UIApplication {
    
    @objc var my_baseApiUrl: String {
        return "https://api.github.com"
    }
    
    @objc var my_baseWebUrl: String {
        return "https://github.com"
    }
    
}

extension Reactive where Base: UIApplication {
    
    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { view, attr in
            globalStatusBarStyle.accept(attr)
        }
    }
    
}
