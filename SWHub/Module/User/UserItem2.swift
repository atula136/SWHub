//
//  UserItem2.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class UserItem2: InfoItem {

    required init(_ model: ModelType) {
        super.init(model)
        var title: String?
        var subtitle: String?
        var icon: URL?
        if let user = model as? User {
            title = user.login
            icon = user.avatar
        } else if let user = model as? TrendingUser {
            title = user.name
            subtitle = user.repo?.name
            icon = user.avatar
        }
        self.initialState = State(
            title: title,
            subtitle: subtitle,
            icon: icon
        )
    }

}
