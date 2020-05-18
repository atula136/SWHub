//
//  LoginViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift
import ReactorKit
import SWFrame

class LoginViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case login
        case account(String?)
        case password(String?)
    }

    enum Mutation {
        case setLoading(Bool)
        case setAccount(String?)
        case setPassword(String?)
        case setUser(User)
    }

    struct State {
        var isLoading = false
        var title: String?
        var account: String?
        var password: String?
        var user: User?
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.login())
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .account(let account):
            return .just(.setAccount(account))
        case .password(let password):
            return .just(.setPassword(password))
        case .login:
            guard let account = self.currentState.account else { return .empty() }
            guard let password = self.currentState.password else { return .empty() }
            guard !self.currentState.isLoading else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                self.provider.login(account: account, password: password).map(Mutation.setUser),
                .just(.setLoading(false))
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setAccount(account):
            state.account = account
        case let .setPassword(password):
            state.password = password
        case let .setUser(user):
            if let account = state.account,
                let password = state.password {
                User.token = "\(account):\(password)".base64Encoded
            }
            User.login(user)
            state.user = user
        }
        return state
    }
}
