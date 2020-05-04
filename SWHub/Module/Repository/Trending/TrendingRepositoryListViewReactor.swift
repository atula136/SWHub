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
        case initial([TrendingRepository])
    }
    
    struct State {
        var isLoading = false
        var isRefreshing = false
        var title: String?
        var error: Error?
        var sections: [TrendingRepositorySection] = []
    }
    
//    let pageSource = "sec_category"
//    var categoryId: String?
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        // self.categoryId = stringMember(parameters, Parameter.categoryId, nil)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.mainTabBarSearch())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            var load = Observable.just(Mutation.setError(nil))
            load = load.concat(Observable.just(.setLoading(true)))
            if let repositories = TrendingRepository.cachedArray() {
                load = load.concat(Observable.just(.initial(repositories)))
            } else {
                load = load.concat(self.provider.repositories(language: nil, since: "daily").map{ Mutation.initial($0) }.catchError({ .just(.setError($0)) }))
            }
            load = load.concat(Observable.just(.setLoading(false)))
            return load
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.provider.repositories(language: nil, since: "daily").map{ Mutation.initial($0) }.catchError({ .just(.setError($0)) }),
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
        case let .initial(repositories):
            TrendingRepository.storeArray(repositories)
            state.sections = [.repositories(repositories.map{ TrendingRepositorySectionItem.repository(TrendingRepositoryItem($0)) })]
        }
        return state
    }
    
}

