//
//  Enumeration.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

enum ListType: String {
    case watchers
    case stargazers
    case forks
}

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

enum Since: Int, Codable {
    case daily, weekly, monthly

    static let allValues = [daily, weekly, monthly]

    var title: String {
        switch self {
        case .daily: return R.string.localizable.daily()
        case .weekly: return R.string.localizable.weekly()
        case .monthly: return R.string.localizable.monthly()
        }
    }

    var paramValue: String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        }
    }

}
