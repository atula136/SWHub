//
//  Library.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class Library {

    public static func setup() {
        self.setupKeyboardManager()
    }
    
    static func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
}
