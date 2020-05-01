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

class SettingUserItem: RepositoryItem {
    
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