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
        case dark(Bool)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDark(Bool)
        case setError(Error?)
        case setRepository(Repository)
        case start([[ModelType]])
    }
    
    struct State {
        var isLoading = false
        var isDark = false
        var title: String?
        var error: Error?
        var repository: Repository?
        var sections: [SettingSection] = []
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: Dictionary<String, Any>?) {
        super.init(provider, parameters)
        self.initialState = State(
            isDark: ThemeType.currentTheme().isDark,
            title: stringDefault(self.title, R.string.localizable.mainTabBarSetting())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            var sections: [[ModelType]] = []
            if let user = User.current() {
                let logout = Setting(id: .logout)
                sections.append([user, logout])
            }
            if let repository = Repository.current() {
                sections.append([repository])
            }
            var preference: [ModelType] = []
            var dark = Setting(id: .dark, accessory: .none)
            dark.switched = ThemeType.currentTheme().isDark
            preference.append(dark)
            preference.append(Setting(id: .color))
            sections.append(preference)
            return .concat([
                .just(.setLoading(true)),
                .just(.start(sections)),
                self.provider.repository(fullname: "tospery/SWHub").map(Mutation.setRepository).catchError({.just(.setError($0))}),
                .just(.setLoading(false))
            ])
        case let .dark(isDark):
            guard isDark != self.currentState.isDark else { return .empty() }
            return .just(.setDark(isDark))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setDark(isDark):
            state.isDark = isDark
        case let .start(sections):
            state.sections = sections.map { models -> SettingSection in
                var header = R.string.localizable.settingPreferences()
                var items: [SettingSectionItem] = []
                for model in models {
                    if let user = model as? User {
                        header = R.string.localizable.settingAccount()
                        items.append(.profile(SettingProfileItem(user)))
                    }
                    if let repository = model as? Repository {
                        header = R.string.localizable.settingProject()
                        items.append(.project(SettingProjectItem(repository)))
                    }
                    if let setting = model as? Setting {
                        switch setting.id! {
                        case .logout:
                            header = R.string.localizable.settingAccount()
                            items.append(.logout(SettingNormalItem(setting)))
                        case .dark:
                            items.append(.dark(SettingSwitchItem(setting)))
                        case .color:
                            items.append(.color(SettingNormalItem(setting)))
                        default:
                            break
                        }
                    }
                }
                return .setting(header: header, items: items)
            }
        case let .setRepository(repository):
            state.repository = repository
            var sections = state.sections
            if sections.count >= 3 {
                sections.remove(at: 1)
            }
            sections.insert(.setting(header: R.string.localizable.settingProject(), items: [.project(SettingProjectItem(repository))]), at: 1)
            state.sections = sections
            Repository.update(repository)
        case let .setError(error):
            state.error = error
        }
        return state
    }
    
}
