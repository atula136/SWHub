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
        var language: NSAttributedString?
        var stars: NSAttributedString?
        var forks: NSAttributedString?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
//        var title: String?
//        var subtitle: String?
//        var detail: NSAttributedString?
//        var icon: URL?
//        if let repo = model as? Repo {
//            title = repo.fullName
//            subtitle = repo.description
//            detail = repo.detail()
//            icon = repo.owner?.avatar
//        } else if let repo = model as? TrendingRepo {
//            title = "\(repo.author ?? "")/\(repo.name ?? "")"
//            subtitle = repo.description
//            detail = repo.detail(since: Condition.current()!.since.title)
//            icon = repo.avatar
//        }
//        self.initialState = State(
//            title: title,
//            subtitle: subtitle,
//            detail: detail,
//            icon: icon
//        )
        if let repo = model as? TrendingRepo {
            self.initialState = State(
                name: "\(repo.author ?? "")/\(repo.name ?? "")",
                description: repo.description,
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
//        guard let repository = self.model as? TrendingRepo else { return state }
//        return state.flatMap { state -> Observable<State> in
//             var state = state
//             state.detail = repository.detail(since: Condition.current()!.since.title)
//            return .just(state)
//        }
        return state
    }

}
