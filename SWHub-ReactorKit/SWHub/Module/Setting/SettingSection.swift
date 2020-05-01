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
    case setting(header: String, items: [SettingSectionItem])
}

extension SettingSection: SectionModelType {
    var items: [SettingSectionItem] {
        switch self {
        case let .setting(_, items): return items
        }
    }
    
    init(original: SettingSection, items: [SettingSectionItem]) {
        switch original {
        case let .setting(header, items):
            self = .setting(header: header, items: items)
        }
    }
}

enum SettingSectionItem {
    case user(UserItem)
    case logout(LogoutItem)
    //case setting(SettingItem)
}
