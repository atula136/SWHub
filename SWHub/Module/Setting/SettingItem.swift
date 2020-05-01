//
//  SettingItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class SettingItem: NormalItem {
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let setting = model as? Setting else { return }
        self.initialState = State(
            showIndicator: setting.showIndicator,
            showSwitcher: setting.showSwitcher,
            title: setting.title,
            detail: setting.detail,
            icon: setting.icon
        )
    }
    
}
