//
//  RepoDetailViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SwifterSwift
import Highlightr
import ReactorKit
import SWFrame

class RepoDetailViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case setReadme(Repo.Readme)
    }

    struct State {
        var isLoading = false
        var title: String?
        var error: Error?
        var readme: Repo.Readme!
        var sections: [RepoSection] = []
    }

    var fullname: String?
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.fullname = stringMember(self.parameters, Parameter.fullname, nil)
        self.initialState = State(
            title: stringDefault(self.title, self.fullname ?? "")
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let fullname = self.fullname else { return .empty() }
            let requestReadme = self.provider.readme(fullname: fullname).flatMap { [weak self] readme -> Observable<Repo.Readme> in
                guard let `self` = self, let url = readme.downloadUrl else { return .empty() }
                return self.provider.download(url: url).map { content -> Repo.Readme in
                    let highlightr = Highlightr()
                    highlightr?.setTheme(to: "github")
                    var readme = readme
                    readme.highlightedCode = highlightr?.highlight(content)
                    return readme
                }
            }.map { Mutation.setReadme($0) }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                requestReadme,
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
        case let .setReadme(readme):
            state.readme = readme
            state.sections = [.list([.readme(RepoReadmeItem(readme))])]
        }
        return state
    }

}
