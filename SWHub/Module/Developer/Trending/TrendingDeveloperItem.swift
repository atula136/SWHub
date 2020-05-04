//
//  TrendingDeveloperItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class TrendingDeveloperItem: InfoItem {
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let developer = model as? TrendingDeveloper else { return }
        self.initialState = State(
            title: "\(developer.username ?? "")/\(developer.name ?? "")",
            subtitle: "\(developer.username ?? "")/\(developer.repo?.name ?? "")",
            icon: developer.avatar
        )
    }
    
}
