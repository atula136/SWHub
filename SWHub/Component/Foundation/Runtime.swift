//
//  Runtime.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import SWFrame

class Runtime: SWFrame.Runtime {
    override class func work() {
        super.work()
        ExchangeImplementations(UIApplication.self, #selector(getter: UIApplication.baseApiUrl), #selector(getter: UIApplication.myBaseApiUrl))
        ExchangeImplementations(UIApplication.self, #selector(getter: UIApplication.baseWebUrl), #selector(getter: UIApplication.myBaseWebUrl))
        ExchangeImplementations(BaseViewController.self, #selector(BaseViewController.viewDidLoad), #selector(BaseViewController.my_viewDidLoad))
    }
}
