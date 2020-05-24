//
//  RepoListViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SWFrame

class RepoListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
        case loadMore
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setLoadingMore(Bool)
        case setError(Error?)
        case start([Repo])
        case append([Repo])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var noMoreData = false
        var title: String?
        var error: Error?
        var sections: [RepoSection] = []
    }

    var type = ListType.repositories
    var name: String?
    var request: (String, Int) -> Observable<[Repo]> = { _, _ in .empty() }
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let value = stringMember(self.parameters, Parameter.listType, nil)?.int ?? 0
        self.type = ListType(rawValue: value) ?? ListType.repositories
        self.name = stringMember(self.parameters, Parameter.username, nil)
        self.request = { [weak self] (name: String, page: Int) -> Observable<[Repo]> in
            guard let `self` = self else { return .empty() }
            switch self.type {
            case .repositories:
                return provider.userRepos(username: name, page: page)
            case .forks:
                return provider.forks(fullname: name, page: page)
            default:
                return .empty()
            }
        }
        self.initialState = State(
            title: stringDefault(self.title, self.type.title)
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        guard let name = self.name else { return .empty() }
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.request(name, self.pageStart).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex = self.pageStart
                }).map { Mutation.start($0) }.catchError({ .just(.setError($0)) }),
                .just(.setLoading(false))
            ])
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.request(name, self.pageStart).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex = self.pageStart
                }).map { Mutation.start($0) }.catchError({ .just(.setError($0)) }),
                .just(.setRefreshing(false))
            ])
        case .loadMore:
            guard self.currentState.isLoadingMore == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoadingMore(true)),
                self.request(name, self.pageIndex).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex += 1
                }).map { Mutation.append($0) }.catchError({ .just(.setError($0)) }),
                .just(.setLoadingMore(false))
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
        case let .setLoadingMore(isLoadingMore):
            state.isLoadingMore = isLoadingMore
        case let .setError(error):
            state.error = error
        case let .start(repos):
            state.sections = [.list(repos.map { .basic(RepoBasicItem($0)) })]
        case let .append(repos):
            state.noMoreData = repos.count < self.pageSize
            var items = state.sections[0].items
            items += repos.map { .basic(RepoBasicItem($0)) }
            state.sections = [.list(items)]
        }
        return state
    }

}
