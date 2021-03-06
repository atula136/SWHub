//
//  RepoBasicItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/10.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RealmSwift
import Kingfisher
import SWFrame

class RepoBasicItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setNight(Bool)
    }

    struct State {
        var name: String?
        var intro: String?
        var status: String?
        var code: NSAttributedString?
        var stars: NSAttributedString?
        var forks: NSAttributedString?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        let since = Since(rawValue: Subjection.for(Config.self).value?.since ?? 0)?.title ?? Since.daily.title
        self.initialState = State(
            name: repo.fullName ?? "\(repo.author ?? "")/\(repo.name ?? "")",
            intro: repo.introduction,
            status: R.string.localizable.trendingRepoStarsNew(since, repo.currentPeriodStars),
            code: repo.codeText,
            stars: repo.starsText,
            forks: repo.forksText,
            avatar: repo.avatar?.url
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        guard let repo = self.model as? Repo else { return state }
        var state = state
        switch mutation {
        case .setNight:
            state.code = repo.codeText
            state.stars = repo.starsText
            state.forks = repo.forksText
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .turnNight(isNight):
                return .just(.setNight(isNight))
            default: return .empty()
            }
        }
        return .merge(mutation, nightEvent)
    }

}
