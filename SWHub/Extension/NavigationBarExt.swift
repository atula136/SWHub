//
//  NavigationBarExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import NSObject_Rx
import SWFrame

extension NavigationBar {

    @objc func my_init(frame: CGRect) {
        self.my_init(frame: frame)
        themeService.rx
            .bind({ $0.foregroundColor }, to: self.rx.itemColor)
            .bind({ $0.primaryColor }, to: self.rx.backgroundColor)
            .bind({ $0.borderColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.textColor }, to: self.titleLabel.rx.textColor)
            .disposed(by: self.rx.disposeBag)
    }

}
