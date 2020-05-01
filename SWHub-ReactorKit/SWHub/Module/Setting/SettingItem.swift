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

class SettingItem: CollectionItem, ReactorKit.Reactor {
    typealias Action = NoAction
    
    struct State {
        var title: String?
        var detail: NSAttributedString?
        var avatar: URL?
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let setting = model as? Setting else { return }
        self.initialState = State(
            title: setting.title,
            detail: setting.detail,
            avatar: setting.avatar
        )
    }
    
}
