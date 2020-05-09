//
//  UserItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class UserItem: InfoItem {

    required init(_ model: ModelType) {
        super.init(model)
        if let user = model as? User {
            self.initialState = State(title: user.login, icon: user.avatar)
        } else if let developer = model as? TrendingDeveloper {
            self.initialState = State(
                title: "\(developer.username ?? "")/\(developer.name ?? "")",
                subtitle: "\(developer.username ?? "")/\(developer.repo?.name ?? "")",
                icon: developer.avatar
            )
        }
    }

}
