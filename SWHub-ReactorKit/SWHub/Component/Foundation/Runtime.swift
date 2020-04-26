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
        // ExchangeImplementations(NavigationBar.self, #selector(NavigationBar.init(frame:)), #selector(NavigationBar.my_init(frame:)))
    }
    
}
