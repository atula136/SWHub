//
//  HomeViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import SWFrame

class HomeViewReactor: ScrollViewReactor, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String?
        var items: [HomeKey] = [.repository, .developer]
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.mainTabBarHome())
        )
    }
    
}

enum HomeKey {
    case repository
    case developer
    
    var title: String {
        switch self {
        case .repository:
            return R.string.localizable.homeRepository()
        case .developer:
            return R.string.localizable.homeDeveloper()
        }
    }
}
