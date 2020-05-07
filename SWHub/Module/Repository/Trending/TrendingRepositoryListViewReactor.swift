//
//  TrendingRepositoryListViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import ReactorKit
import SWFrame

class TrendingRepositoryListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setError(Error?)
        case setCondition(Condition)
        case start([TrendingRepository])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var title: String?
        var error: Error?
        var condition: Condition!
        var sections: [TrendingRepositorySection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            condition: Condition.current(),
            sections: [.repositories((TrendingRepository.cachedArray() ?? []).map { .repository(TrendingRepositoryItem($0)) })]
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            let urlParam = self.currentState.condition.language.urlParam
            let paramValue = self.currentState.condition.since.paramValue
            let request = self.provider.repositories(language: urlParam, since: paramValue)
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                request.map { Mutation.start($0) }.catchError({ .just(.setError($0)) }),
                .just(.setLoading(false))
            ])
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            let urlParam = self.currentState.condition.language.urlParam
            let paramValue = self.currentState.condition.since.paramValue
            let request = self.provider.repositories(language: urlParam, since: paramValue)
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                request.map { Mutation.start($0) }.catchError({ .just(.setError($0)) }),
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
        case let .setCondition(condition):
            state.condition = condition
        case let .start(repositories):
            TrendingRepository.storeArray(repositories)
            state.sections = [.repositories(repositories.map { .repository(TrendingRepositoryItem($0)) })]
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(
            mutation,
            Condition.subject().asObservable().filterNil().distinctUntilChanged().map(Mutation.setCondition)
        )
    }
}
