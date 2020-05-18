//
//  RepoDetailHeaderReactor2.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import SWFrame

class RepoDetailHeaderReactor2: SupplementaryReactor, ReactorKit.Reactor {

    typealias Action = NoAction

    struct State {
        // var starred = false
        var avatar: URL?
        var title: String?
        var follow: NSAttributedString?
        var star: NSAttributedString?
        var fork: NSAttributedString?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let repository = model as? Repo else { return }
        self.initialState = State(
            avatar: repository.owner?.avatar?.url,
            title: repository.description,
            follow: repository.count(title: R.string.localizable.watchs(), value: repository.watchersCount),
            star: repository.count(title: R.string.localizable.stars(), value: repository.stargazersCount),
            fork: repository.count(title: R.string.localizable.forks(), value: repository.forksCount)
        )
    }
}
