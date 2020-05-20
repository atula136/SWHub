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
import SWFrame

class Appearance {

    static let disposeBag = DisposeBag()

    public class func config() {
        // 导航栏
        let navBar = NavigationBar.appearance()
        themeService.rx
            .bind({ $0.tintColor }, to: navBar.rx.itemColor)
            .bind({ $0.dimColor }, to: navBar.rx.backgroundColor)
            .bind({ $0.borderColor }, to: navBar.rx.lineColor)
            .bind({ $0.titleColor }, to: navBar.rx.titleColor)
            .disposed(by: self.disposeBag)
    }

}
