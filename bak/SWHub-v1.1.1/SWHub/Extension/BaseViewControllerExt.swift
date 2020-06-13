//
//  BaseViewControllerExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/22.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import NSObject_Rx
import SWFrame

extension BaseViewController {

    @objc func my_viewDidLoad() {
        self.my_viewDidLoad()
        themeService.rx
            .bind({ $0.tintColor }, to: self.navigationBar.rx.itemColor)
            .bind({ $0.dimColor }, to: self.navigationBar.rx.backgroundColor)
            .bind({ $0.borderColor }, to: self.navigationBar.rx.lineColor)
            .bind({ $0.titleColor }, to: self.navigationBar.rx.titleColor)
            .disposed(by: self.rx.disposeBag)
    }

}
