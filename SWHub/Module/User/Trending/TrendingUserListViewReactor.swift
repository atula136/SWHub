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
        case start([TrendingUser], toCache: Bool)
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var title: String?
        var error: Error?
        var sections: [TrendingUserSection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            var load = Observable.just(Mutation.setError(nil))
            load = load.concat(Observable.just(.setLoading(true)))
            if let developers = TrendingUser.cachedArray() {
                load = load.concat(Observable.just(.start(developers, toCache: false)))
            } else {
                load = load.concat(self.provider.developers(language: nil, since: "daily").map { Mutation.start($0, toCache: true) }.catchError({ .just(.setError($0)) }))
            }
            load = load.concat(Observable.just(.setLoading(false)))
            return load
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.provider.developers(language: nil, since: "daily").map { Mutation.start($0, toCache: true) }.catchError({ .just(.setError($0)) }),
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
        case let .start(users, toCache):
            if toCache {
                TrendingUser.storeArray(users)
            }
            state.sections = [.users(users.map { TrendingUserSectionItem.user(UserBasicItem($0)) })]
        }
        return state
    }

}
