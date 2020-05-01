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
import RxOptional
import SWFrame

class SettingViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
        //case update
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setRepository(Repository)
        case setError(Error?)
        case initial([ModelType])
    }
    
    struct State {
        var isLoading = false
        //var isUpdating = false
        var title: String?
        var error: Error?
        var repository: Repository?
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
                self.provider.repository(user: "tospery", project: "SWHub").map(Mutation.setRepository).catchError({.just(.setError($0))}),
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
                    return .user(SettingUserItem(user))
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
        case let .setRepository(repository):
            state.repository = repository
            state.sections.insert(.setting(header: R.string.localizable.settingMyProject(), items: [.repository(SettingProjectItem(repository))]), at: 1)
        case let .setError(error):
            state.error = error
        }
        return state
    }
    
}
