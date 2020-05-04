//
//  Enumeration.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

enum TrendingSince {
    case daily, weekly, monthly

//    var title: String {
//        switch self {
//        case .daily: return R.string.localizable.searchDailySegmentTitle.key.localized()
//        case .weekly: return R.string.localizable.searchWeeklySegmentTitle.key.localized()
//        case .montly: return R.string.localizable.searchMonthlySegmentTitle.key.localized()
//        }
//    }

    var value: String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        }
    }
    
}
