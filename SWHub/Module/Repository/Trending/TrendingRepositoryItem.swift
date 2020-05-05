//
//  TrendingRepositoryItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class TrendingRepositoryItem: InfoItem {
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let repository = model as? TrendingRepository else { return }
        self.initialState = State(
            title: "\(repository.author ?? "")/\(repository.name ?? "")",
            subtitle: repository.description,
            detail: repository.detail(since: "每日"),
            icon: repository.avatar
        )
    }
    
    override func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNight(_):
            if let repository = self.model as? TrendingRepository {
                state.detail = repository.detail(since: "每日")
            }
        }
        return state
    }
    
}
