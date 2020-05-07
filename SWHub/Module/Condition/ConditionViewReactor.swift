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
        case since(Int)
        case language(String?)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case setSince(Int)
        case setLanguage(String?)
        case start([Condition.Language])
    }
    
    struct State {
        var isLoading = false
        var error: Error?
        var since = Condition.Since.daily
        var language = Condition.Language.init(name: "All languages")
        var sections: [Condition.Language.Section] = []
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let condition = Condition.current()!
        // since
        let value = stringMember(self.parameters, Parameter.since, condition.since.paramValue)!
        let since = value.since
        // language
        let urlParam = stringMember(self.parameters, Parameter.language, condition.language.urlParam)
        var language = Condition.Language.init()
        language.urlParam = urlParam
        // sections
        var sections: [Condition.Language.Section] = []
        if let languages = Condition.Language.cachedArray() {
            let langs = self.languages(languages: languages, selected: language.urlParam)
            let items = langs.map { Condition.Language.Item($0) }
            let sectionItems = items.map { Condition.Language.SectionItem.language($0) }
            sections = [.languages(sectionItems)]
        }
        self.initialState = State(
            since: since,
            language: language,
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
                self.provider.languages().map { Mutation.start($0) },
                .just(.setLoading(false))
            ])
        case let .since(value):
            guard value != self.currentState.since.rawValue else { return .empty() }
            return .just(.setSince(value))
        case let .language(urlParam):
            guard urlParam != self.currentState.language.urlParam else { return .empty() }
            return .just(.setLanguage(urlParam))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = error
        case let .setSince(value):
            if let since = Condition.Since.init(rawValue: value) {
                state.since = since
            }
        case let .setLanguage(urlParam):
            var language = Condition.Language.init()
            language.urlParam = urlParam
            state.language = language
        case let .start(languages):
            Condition.Language.storeArray(languages)
            let langs = self.languages(languages: languages, selected: state.language.urlParam)
            state.sections = [.languages(langs.map { Condition.Language.Item($0) }.map { Condition.Language.SectionItem.language($0) })]
        }
        return state
    }
    
    func languages(languages: [Condition.Language], selected: String?) -> [Condition.Language] {
        var langs = languages
        langs.insert(Condition.Language.init(), at: 0)
        for (index, lang) in langs.enumerated() {
            if lang.urlParam == selected {
                var selected = lang
                selected.checked = true
                langs.remove(at: index)
                langs.insert(selected, at: index)
                break
            }
        }
        return langs
    }
    
}

