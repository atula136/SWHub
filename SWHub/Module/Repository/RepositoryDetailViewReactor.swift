//
//  RepositoryDetailViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SWFrame

class RepositoryDetailViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case setRepository(Repository)
        // case start([Condition.Language])
    }
    
    struct State {
        var isLoading = false
        var title: String?
        var error: Error?
        var repository: Repository!
        var sections: [RepositoryDetailSection] = []
    }
    
    var fullname: String?
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
//        let fullname = stringMember(self.parameters, Parameter.fullname, nil)
//        var repository = Repository.init()
//        repository.fullName = fullname
        self.fullname = stringMember(self.parameters, Parameter.fullname, nil)
//        let condition = Condition.current()!
//        // since
//        let value = stringMember(self.parameters, Parameter.since, condition.since.paramValue)!
//        let since = value.since
//        // language
//        let urlParam = stringMember(self.parameters, Parameter.language, condition.language.urlParam)
//        var language = Condition.Language.init()
//        language.urlParam = urlParam
//        // sections
//        var sections: [Condition.Language.Section] = []
//        if let languages = Condition.Language.cachedArray() {
//            let langs = self.languages(languages: languages, selected: language.urlParam)
//            let items = langs.map { Condition.Language.Item($0) }
//            let sectionItems = items.map { Condition.Language.SectionItem.language($0) }
//            sections = [.languages(sectionItems)]
//        }
        self.initialState = State(
            title: stringDefault(self.title, self.fullname ?? "")
            // repository: repository
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let fullname = self.fullname else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.provider.repository(fullname: fullname).map { Mutation.setRepository($0) },
                .just(.setLoading(false))
            ])
//        case let .since(value):
//            guard value != self.currentState.since.rawValue else { return .empty() }
//            return .just(.setSince(value))
//        case let .language(urlParam):
//            guard urlParam != self.currentState.language.urlParam else { return .empty() }
//            return .just(.setLanguage(urlParam))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = error
        case let .setRepository(repository):
            state.repository = repository
            let items = RepositoryDetailModel.Key.allValues.map { key -> RepositoryDetailSectionItem in
                var model = RepositoryDetailModel(key: key)
                switch key {
                case .branch:
                    model.detail = repository.defaultBranch
                case .star:
                    model.detail = Constant.Network.starHistoryUrl
                default:
                    break
                }
                return .detail(RepositoryDetailItem(model))
            }
            state.sections = [.details(items)]
        }
        return state
    }
//
//    func languages(languages: [Condition.Language], selected: String?) -> [Condition.Language] {
//        var langs = languages
//        langs.insert(Condition.Language.init(), at: 0)
//        for (index, lang) in langs.enumerated() {
//            if lang.urlParam == selected {
//                var selected = lang
//                selected.checked = true
//                langs.remove(at: index)
//                langs.insert(selected, at: index)
//                break
//            }
//        }
//        return langs
//    }
    
}
