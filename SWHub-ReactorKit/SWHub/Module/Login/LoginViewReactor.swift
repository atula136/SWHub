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
import ReactorKit
import SWFrame

class LoginViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case login
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setUser(User?)
    }
    
    struct State {
        var isLoading = false
        var title: String?
        var user: User?
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.loginTitle())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login:
            guard !self.currentState.isLoading else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
//                self.provider.auth(sender: UIViewController.topMost!).flatMap({ session -> Observable<User> in
//                    let user1: ALBBUser = session.getUser()
//                    let token = (user1.openId + Constant.Platform.Alibc.appSecret).qmui_md5
//                    return self.provider.login(nickName: user1.nick, avatarUrl: user1.avatarUrl.urlEncoded, openId: user1.openId, token: token)
//                }).flatMap({ user2 -> Observable<User?> in
//                    return self.provider.userInfo().map { user3 -> User in
//                        var user = user2
//                        user.info = user3.info
//                        user.inviter = user3.inviter
//                        return user
//                    }
//                }).do(onNext: { user5 in
//                    User.update(user5)
//                }).catchErrorJustReturn(nil).map(Mutation.setUser),
                .just(.setLoading(false)),
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setUser(user):
            state.user = user
        }
        return state
    }
    
}
