//
//  UserListViewReactor.swift
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

class UserListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

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
        case start([User], toCache: Bool)
        case append([User])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var isLoadingMore = false
        var noMoreData = false
        var title: String?
        var error: Error?
        var sections: [UserListSection] = []
    }

    var fullname: String?
    var request: (String, Int) -> Observable<[User]> = { _, _ in .empty() }
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let list = ListType.init(rawValue: stringDefault(stringMember(self.parameters, Parameter.list, nil), ListType.watchers.rawValue)) ?? ListType.watchers
        self.request = { (fullname: String, page: Int) -> Observable<[User]> in
            switch list {
            case .watchers:
                return provider.watchers(fullname: fullname, page: page)
            case .stargazers:
                return provider.stargazers(fullname: fullname, page: page)
            default:
                return .empty()
            }
        }
        self.fullname = stringMember(self.parameters, Parameter.fullname, nil)
        self.initialState = State(
            title: self.title
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        guard let fullname = self.fullname else { return .empty() }
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.request(fullname, self.pageStart).map { Mutation.start($0, toCache: false) }.catchError({ .just(.setError($0)) }).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex = self.pageStart
                }),
                .just(.setLoading(false))
            ])
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.request(fullname, self.pageStart).map { Mutation.start($0, toCache: false) }.catchError({ .just(.setError($0)) }).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex = self.pageStart
                }),
                .just(.setRefreshing(false))
            ])
        case .loadMore:
            guard self.currentState.isLoadingMore == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoadingMore(true)),
                self.request(fullname, self.pageIndex).map { Mutation.append($0) }.catchError({ .just(.setError($0)) }).do(onCompleted: { [weak self] in
                    guard let `self` = self else { return }
                    self.pageIndex += 1
                }),
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
        case let .start(users, toCache):
            if toCache {
                User.storeArray(users)
            }
            state.sections = [.users(users.map { .user(UserItem2($0)) })]
        case let .append(users):
            state.noMoreData = users.count < self.pageSize
            var items = state.sections[0].items
            items += users.map { .user(UserItem2($0)) }
            state.sections = [.users(items)]
        }
        return state
    }

}
