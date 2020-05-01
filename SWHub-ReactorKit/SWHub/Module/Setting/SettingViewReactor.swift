//
//  SettingViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Rswift
import ReactorKit
import SWFrame

class SettingViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case initial([ModelType])
    }
    
    struct State {
        var isLoading = false
        var title: String?
        var sections = [SettingSection]()
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.mainTabBarSetting())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
//            var user = Setting(id: .user)
//            if let current = User.current() {
//                user.title = current.login
//                user.avatar = current.avatar
//                user.detail = current.detail()
//            }
            var models = [ModelType]()
            if let user = User.current() {
                models.append(user)
            }
            var logout = Setting(id: .logout)
            logout.indicated = false
            logout.title = R.string.localizable.settingAccountLogout()
            logout.icon = R.image.setting_cell_logout()?.template
            models.append(logout)
            return .concat([
                .just(.setLoading(true)),
                .just(.initial(models)),
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .initial(models):
            let items = models.map { model -> SettingSectionItem in
                if let user = model as? User {
                    return .user(UserItem(user))
                }
                let setting = model as! Setting
                switch setting.id! {
                case .logout:
                    return .logout(SettingItem(setting))
                default:
                    return .logout(SettingItem(setting))
                }
            }
            state.sections = [.setting(header: R.string.localizable.settingAccount(), items: items)]
        }
        return state
    }
    
}
