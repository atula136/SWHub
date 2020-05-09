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
    }

    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case start([User], toCache: Bool)
    }

    struct State {
        var isLoading = false
        var title: String?
        var error: Error?
        var sections: [UserListSection] = []
    }

    var fullname: String?
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.fullname = stringMember(self.parameters, Parameter.fullname, nil)
        self.initialState = State(
            title: self.title
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
                self.provider.watchers(fullname: fullname, page: self.pageIndex).map { Mutation.start($0, toCache: false) }.catchError({ .just(.setError($0)) }),
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
        case let .start(users, toCache):
            if toCache {
                User.storeArray(users)
            }
            state.sections = [.users(users.map { .user(UserItem($0)) })]
        }
        return state
    }

}
