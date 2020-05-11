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
            createDate: user.createdAt,
            avatar: user.avatar
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
//        guard let user = self.model as? TrendingUser else { return state }
//        return state.flatMap { state -> Observable<State> in
//            var state = state
//            state.repo = user.repoText()
//            return .just(state)
//        }
//    }

}
