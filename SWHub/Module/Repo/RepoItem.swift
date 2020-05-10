//
//  RepoItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/10.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class RepoItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setDark(Bool)
    }

    struct State {
        var name: String?
        var description: String?
        var status: String?
        var language: NSAttributedString?
        var stars: NSAttributedString?
        var forks: NSAttributedString?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        if let repo = model as? Repo {
            self.initialState = State(
                name: repo.fullName,
                description: repo.description,
                avatar: repo.owner?.avatar
            )
        } else if let repo = model as? TrendingRepo {
            self.initialState = State(
                name: "\(repo.author ?? "")/\(repo.name ?? "")",
                description: repo.description,
                status: R.string.localizable.trendingRepoStarsNew(Condition.current()!.since.title, repo.currentPeriodStars ?? 0),
                language: repo.languageText(),
                stars: repo.starsText(),
                forks: repo.forksText(),
                avatar: repo.avatar
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .night(isNight):
                return .just(.setDark(isNight))
            }
        }
        return .merge(mutation, nightEvent)
    }

    func transform(state: Observable<State>) -> Observable<State> {
        guard let repo = self.model as? TrendingRepo else { return state }
        return state.flatMap { state -> Observable<State> in
            var state = state
            state.language = repo.languageText()
            state.stars = repo.starsText()
            state.forks = repo.forksText()
            return .just(state)
        }
    }

}
