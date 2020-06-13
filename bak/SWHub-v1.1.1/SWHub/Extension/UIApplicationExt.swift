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

    @objc var myBaseApiUrl: String {
        return "https://api.github.com"
    }

    @objc var myBaseWebUrl: String {
        return "https://github.com"
    }

}

extension Reactive where Base: UIApplication {

    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { _, attr in
            globalStatusBarStyle.accept(attr)
        }
    }

}
