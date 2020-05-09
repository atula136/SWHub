//
//  Appearance.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class Appearance {

    static let disposeBag = DisposeBag()

    public class func config() {
        // 导航栏
//        let navBar = UINavigationBar.appearance()
//        themeService.rx
//            .bind({ $0.primaryColor }, to: navBar.rx.barTintColor)
//            .bind({ $0.foregroundColor }, to: navBar.rx.tintColor)
//            .bind({ [.foregroundColor: $0.textColor, .font: UIFont.systemFont(ofSize: 17)] }, to: navBar.rx.titleTextAttributes)
//            .disposed(by: self.disposeBag)
//        navBar.isTranslucent = false
    }
}
