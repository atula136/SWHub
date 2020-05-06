//
//  SettingSwitchItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SwifterSwift
import SWFrame

class SettingSwitchItem: DefaultItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var switched = false
        var icon: ImageSource?
        var title: String?
        var detail: NSAttributedString?
        var accessory = AccessoryType.indicator
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let setting = model as? Setting else { return }
        self.initialState = State(
            switched: setting.switched,
            icon: setting.icon,
            title: setting.title,
            detail: setting.detail,
            accessory: setting.accessory
        )
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        return state
    }
    
}

