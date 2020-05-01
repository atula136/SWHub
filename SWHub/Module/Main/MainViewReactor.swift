//
//  MainViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import SWFrame

class MainViewReactor: TabBarViewReactor, ReactorKit.Reactor {

    typealias Action = NoAction
    
    struct State {
        let keys: [MainKey] = [
            .message, .search, .activity, .setting
        ]
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
        )
    }
    
}


enum MainKey {
    case message
    case search
    case activity
    case setting
}