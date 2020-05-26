//
//  AccessoryType.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/17.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

enum AccessoryType: Equatable {
    case none
    case indicator
    case checkmark

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.indicator, .indicator),
             (.checkmark, .checkmark):
            return true
        default:
            return false
        }
    }
}
