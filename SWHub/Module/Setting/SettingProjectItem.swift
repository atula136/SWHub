//
//  SettingProjectItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class SettingProjectItem: InfoItem {

    required init(_ model: ModelType) {
        super.init(model)
        guard let repository = model as? Repo else { return }
        self.initialState = State(
            title: repository.fullName,
            subtitle: repository.description,
            detail: repository.detail(),
            icon: repository.owner?.avatar
        )
    }

    override func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setDark:
            if let repository = self.model as? Repo {
                state.detail = repository.detail()
            }
        }
        return state
    }
}
