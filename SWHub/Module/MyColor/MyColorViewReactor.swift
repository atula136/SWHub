//
//  MyColorViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import SWFrame

class MyColorViewReactor: BaseViewReactor, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String?
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.settingPreferencesTheme())
        )
    }
    
}