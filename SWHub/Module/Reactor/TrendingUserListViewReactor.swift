//
//  TrendingUserListViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import ReactorKit
import SWFrame

class TrendingUserListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setError(Error?)
        case setCondition(Since, Code)
        case start([User])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var title: String?
        var error: Error?
        var since = Since.daily
        var code = Code.default
        var sections: [UserSection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let realm = try! Realm()
        let config = Subjection.for(Config.self).value
        var users: [User] = []
        for user in realm.objects(User.self).filter("#first = true") {
            users.append(user)
        }
        self.initialState = State(
            since: Since(rawValue: config?.since ?? 0) ?? Since.daily,
            code: Code(value: ["id": config?.codeId]),
            sections: [.list(users.map { .basic(UserBasicItem($0)) })]
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.provider.users(language: self.currentState.code.id, since: self.currentState.since.paramValue).map { Mutation.start($0) }.catchError { .just(.setError($0))},
                .just(.setLoading(false))
            ])
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.provider.users(language: self.currentState.code.id, since: self.currentState.since.paramValue).map { Mutation.start($0) }.catchError { .just(.setError($0))},
                .just(.setRefreshing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        case let .setError(error):
            state.error = error
        case let .setCondition(since, code):
            state.since = since
            state.code = code
        case let .start(models):
            let users = models.map { user -> User in
                user.first = true
                return user
            }
            let realm = Realm.default
            realm.beginWrite()
            realm.add(users, update: .modified)
            try! realm.commitWrite()
            state.sections = [.list(users.map { .basic(UserBasicItem($0)) })]
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let condition = Condition.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .update(since, code):
                return .just(.setCondition(since, code))
            }
        }
        return .merge(mutation, condition)
    }

}
