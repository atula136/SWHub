//
//  Library.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SWFrame

class Library: SWFrame.Library {

    override class func setup() {
        super.setup()
        self.setupKeyboardManager()
    }

    class func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

}
