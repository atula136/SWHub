//
//  HomeViewReactor.swift
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

class HomeViewReactor: ScrollViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLanguages([Condition.Language])
    }
    
    struct State {
        var isLoading = false
        var title: String?
        var languages: [Condition.Language]?
        var items: [HomeKey] = [.repository, .developer]
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.mainTabBarHome())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            var load = Observable.just(Mutation.setLoading(true))
            load = load.concat(self.provider.languages().map{ Mutation.setLanguages($0) })
            load = load.concat(Observable.just(.setLoading(false)))
            return load
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setLanguages(languages):
            state.languages = languages
            Condition.Language.storeArray(languages)
        }
        return state
    }
    
}

enum HomeKey {
    case repository
    case developer
    
    var title: String {
        switch self {
        case .repository:
            return R.string.localizable.homeRepository()
        case .developer:
            return R.string.localizable.homeDeveloper()
        }
    }
}
