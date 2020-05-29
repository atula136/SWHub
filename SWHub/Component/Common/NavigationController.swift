//
//  NavigationController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxSwiftExt
import SWFrame

class NavigationController: SWFrame.NavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        globalStatusBarStyle.mapTo(()).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.setNeedsStatusBarAppearanceUpdate()
        }).disposed(by: self.rx.disposeBag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

}
