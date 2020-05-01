//
//  UserItem.swift
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

class UserItem: CollectionItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String?
        var detail: NSAttributedString?
        var icon: URL?
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            title: user.login,
            detail: user.detail(),
            icon: user.avatar
        )
    }
    
}
