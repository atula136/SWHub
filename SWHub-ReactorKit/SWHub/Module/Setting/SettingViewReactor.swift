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
        case initial([[ModelType]])
    }
    
    struct State {
        var isLoading = false
        //var isUpdating = false
        var title: String?
        var error: Error?
        var repository: Repository?
        var sections: [SettingSection] = []
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
            var sections: [[ModelType]] = []
            var account: [ModelType] = []
            if let user = User.current() {
                account.append(user)
                var logout = Setting(id: .logout)
                logout.indicated = false
                logout.title = R.string.localizable.settingAccountLogout()
                logout.icon = R.image.setting_cell_logout()?.template
                account.append(logout)
                sections.append(account)
            }
            var preference: [ModelType] = []
            preference.append(Setting(id: .night, title: R.string.localizable.settingPreferencesNight()))
            preference.append(Setting(id: .theme, title: R.string.localizable.settingPreferencesTheme()))
            sections.append(preference)
            return .concat([
                .just(.setLoading(true)),
                .just(.initial(sections)),
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
        case let .initial(sections):
            state.sections = sections.map { models -> SettingSection in
                var header = R.string.localizable.settingPreferences()
                var items: [SettingSectionItem] = []
                for model in models {
                    if let user = model as? User {
                        header = R.string.localizable.settingAccount()
                        items.append(.user(SettingUserItem(user)))
                    }
                    if let setting = model as? Setting {
                        let item = SettingItem(setting)
                        switch setting.id! {
                        case .logout:
                            header = R.string.localizable.settingAccount()
                            items.append(.logout(item))
                        case .night:
                            items.append(.night(item))
                        case .theme:
                            items.append(.theme(item))
                        }
                    }
                }
                return .setting(header: header, items: items)
            }
        case let .setRepository(repository):
            state.repository = repository
            state.sections.insert(.setting(header: R.string.localizable.settingMyProject(), items: [.repository(SettingProjectItem(repository))]), at: 1)
        case let .setError(error):
            state.error = error
        }
        return state
    }
    
}
