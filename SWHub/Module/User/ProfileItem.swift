//
//  ProfileItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/11.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class ProfileItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setDark(Bool)
    }

    struct State {
        var name: String?
        var description: String?
        var company: String?
        var location: String?
        var email: String?
        var blog: String?
        var reposText: NSAttributedString?
        var followersText: NSAttributedString?
        var followingText: NSAttributedString?
        var createDate: Date?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            name: user.login,
            description: user.bio,
            company: user.company,
            location: user.location,
            email: user.email,
            blog: user.blog,
            reposText: user.count(title: R.string.localizable.repositories(), value: user.publicRepos + user.totalPrivateRepos),
            followersText: user.count(title: R.string.localizable.followers(), value: user.followers),
            followingText: user.count(title: R.string.localizable.following(), value: user.following),
            createDate: user.createdAt,
            avatar: user.avatar?.url
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

    func transform(state: Observable<State>) -> Observable<State> {
        guard let user = self.model as? User else { return state }
        return state.flatMap { state -> Observable<State> in
            var state = state
            state.reposText = user.count(title: R.string.localizable.repositories(), value: user.publicRepos + user.totalPrivateRepos)
            state.followersText = user.count(title: R.string.localizable.followers(), value: user.followers)
            state.followingText = user.count(title: R.string.localizable.following(), value: user.following)
            return .just(state)
        }
    }

}
