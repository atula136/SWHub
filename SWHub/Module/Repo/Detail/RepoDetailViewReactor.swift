//
//  RepoDetailViewReactor.swift
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

class RepoDetailViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case star(Bool)
    }

    enum Mutation {
        case setLoading(Bool)
        case setActivating(Bool)
        case setStarred(Bool)
        case setError(Error?)
        case setRepository(Repo)
    }

    struct State {
        var isLoading = false
        var isActivating = false
        var starred = false
        var title: String?
        var error: Error?
        var repository: Repo!
        var sections: [RepoDetailSection] = []
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
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.provider.repo(fullname: fullname).map { Mutation.setRepository($0) },
                self.provider.checkStarring(fullname: fullname).map { Mutation.setStarred($0) },
                .just(.setLoading(false))
            ])
        case let .star(star):
            guard self.currentState.starred != star else { return .empty() }
            guard let fullname = self.fullname else { return .empty() }
            let request = star ? self.provider.starRepo(fullname: fullname) : self.provider.unstarRepo(fullname: fullname)
            return .concat([
                .just(.setActivating(true)),
                request.map { Mutation.setStarred(star) },
                .just(.setActivating(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setActivating(isActivating):
            state.isActivating = isActivating
        case let .setStarred(starred):
            state.starred = starred
        case let .setError(error):
            state.error = error
        case let .setRepository(repository):
            state.repository = repository
            let items = RepoDetailModel.Key.allValues.map { key -> RepoDetailSectionItem in
                var model = RepoDetailModel(key: key)
                switch key {
                case .branch:
                    model.detail = repository.defaultBranch
                case .star:
                    model.detail = Constant.Network.starHistoryUrl
                default:
                    break
                }
                return .detail(RepoDetailItem(model))
            }
            state.sections = [.details(items)]
        }
        return state
    }

}
