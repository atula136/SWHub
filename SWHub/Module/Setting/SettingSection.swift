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
    case settings(header: String, items: [SettingSectionItem])
}

extension SettingSection: SectionModelType {
    var header: String {
        switch self {
        case let .settings(header, _): return header
        }
    }

    var items: [SettingSectionItem] {
        switch self {
        case let .settings(_, items): return items
        }
    }

    init(original: SettingSection, items: [SettingSectionItem]) {
        switch original {
        case let .settings(header, items):
            self = .settings(header: header, items: items)
        }
    }
}

enum SettingSectionItem {
    case profile(ProfileItem)
    case login(SettingLoginItem)
    case night(SettingSwitchItem)
    case color(SettingNormalItem)
    case cache(SettingNormalItem)
}
