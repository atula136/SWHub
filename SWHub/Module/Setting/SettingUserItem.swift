//
//  SettingUserItem.swift
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

class SettingUserItem: InfoItem {
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            title: user.login,
            detail: user.detail(),
            icon: user.avatar
        )
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNight(_):
            if let user = self.model as? User {
                state.detail = user.detail()
            }
        }
        return state
    }
    
}
