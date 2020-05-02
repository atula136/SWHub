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
import SWFrame

class NavigationController: SWFrame.NavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        themeService.rx
            .bind({ $0.primaryColor }, to: self.navigationBar.rx.barTintColor)
            .bind({ $0.foregroundColor }, to: self.navigationBar.rx.tintColor)
            .bind({ [.foregroundColor: $0.textColor, .font: UIFont.systemFont(ofSize: 17)] }, to: self.navigationBar.rx.titleTextAttributes)
            .disposed(by: self.rx.disposeBag)
        
        globalStatusBarStyle.mapToVoid().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let root1 = self.qmui_rootViewController
            self.setNeedsStatusBarAppearanceUpdate()
        }).disposed(by: self.rx.disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let root2 = self.qmui_rootViewController
        return globalStatusBarStyle.value
    }
    
}
