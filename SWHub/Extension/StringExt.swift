//
//  StringExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

extension String {

    var since: Condition.Since {
        switch self {
        case Condition.Since.daily.paramValue:
            return .daily
        case Condition.Since.weekly.paramValue:
            return .weekly
        case Condition.Since.monthly.paramValue:
            return .monthly
        default:
            return .daily
        }
    }

}
