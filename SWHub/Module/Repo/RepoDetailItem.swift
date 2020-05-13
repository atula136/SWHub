//
//  RepoDetailItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import ReactorKit
import Kingfisher
import SWFrame

class RepoDetailItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setDark(Bool)
    }

    struct State {
        var name: String?
        var detail: NSAttributedString?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            name: repo.fullName,
            detail: repo.detail(),
            avatar: repo.owner?.avatar
        )
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

//    func transform(state: Observable<State>) -> Observable<State> {
//        guard let user = self.model as? User else { return state }
//        return state.flatMap { state -> Observable<State> in
//            var state = state
//            state.reposText = user.count(title: R.string.localizable.repositories(), value: (user.publicRepos ?? 0) + (user.totalPrivateRepos ?? 0))
//            state.followersText = user.count(title: R.string.localizable.followers(), value: (user.followers ?? 0))
//            state.followingText = user.count(title: R.string.localizable.following(), value: (user.following ?? 0))
//            return .just(state)
//        }
//    }

}
