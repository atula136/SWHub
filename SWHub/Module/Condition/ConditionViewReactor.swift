//
//  ConditionViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SWFrame

class ConditionViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case start([Condition.Language])
    }
    
    struct State {
        var isLoading = false
        var error: Error?
        var since = Condition.Since.daily
        var sections: [Condition.Language.Section] = []
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        // since
        let `default` = Misc.current()!.since.rawValue.string
        let value = stringMember(self.parameters, Parameter.since, `default`)
        let since = Condition.Since(rawValue: value?.int ?? 0) ?? Misc.current()!.since
        // sections
        var sections: [Condition.Language.Section] = []
        if var languages = Condition.Language.cachedArray() {
            languages.insert(Condition.Language.init(), at: 0)
            let items = languages.map{ Condition.Language.Item($0) }
            let sectionItems = items.map{ Condition.Language.SectionItem.language($0) }
            sections = [.languages(sectionItems)]
        }
        self.initialState = State(
            since: since,
            sections: sections
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.provider.languages().map{ Mutation.start($0) },
                .just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = error
        case var .start(languages):
            Condition.Language.storeArray(languages)
            languages.insert(Condition.Language.init(), at: 0)
            state.sections = [.languages(languages.map{ Condition.Language.Item($0) }.map{ Condition.Language.SectionItem.language($0) })]
        }
        return state
    }
    
}

