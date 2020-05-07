//
//  SearchViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import SWFrame

class SearchViewReactor: BaseViewReactor, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String?
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.mainTabBarSearch())
        )
    }
    
}
