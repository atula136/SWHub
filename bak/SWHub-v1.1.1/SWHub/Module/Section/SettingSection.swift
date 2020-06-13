//
//  SettingSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum SettingSection {
    case list([SettingSectionItem])
}

extension SettingSection: SectionModelType {

    var items: [SettingSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }

    init(original: SettingSection, items: [SettingSectionItem]) {
        switch original {
        case let .list(items):
            self = .list(items)
        }
    }
}

enum SettingSectionItem {
    case profile(UserProfileItem)
    case login(SettingLoginItem)
    case night(SettingSwitchItem)
    case color(SettingNormalItem)
    case cache(SettingNormalItem)
}
