//
//  RepoItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class RepoItem: InfoItem {

    required init(_ model: ModelType) {
        super.init(model)
        var title: String?
        var subtitle: String?
        var detail: NSAttributedString?
        var icon: URL?
        if let repo = model as? Repo {
            title = repo.fullName
            subtitle = repo.description
            detail = repo.detail()
            icon = repo.owner?.avatar
        } else if let repo = model as? TrendingRepo {
            title = "\(repo.author ?? "")/\(repo.name ?? "")"
            subtitle = repo.description
            detail = repo.detail(since: Condition.current()!.since.title)
            icon = repo.avatar
        }
        self.initialState = State(
            title: title,
            subtitle: subtitle,
            detail: detail,
            icon: icon
        )
    }

    override func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setDark:
            if let repo = model as? Repo {
                state.detail = repo.detail()
            } else if let repo = model as? TrendingRepo {
                state.detail = repo.detail(since: Condition.current()!.since.title)
            }
        }
        return state
    }

}
