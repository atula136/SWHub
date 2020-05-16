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
        case login
        case night(Bool)
    }

    enum Mutation {
        case setLoading(Bool)
        case setUser(User?)
        case setNight(Bool)
        case setError(Error?)
        case setRepo(Repo)
        case start([[ModelType]])
    }

    struct State {
        var isLoading = false
        var isNight = false
        var title: String?
        var error: Error?
        var user: User?
        var repo: Repo?
        var sections: [SettingSection] = []
    }

    let fullName = "tospery/SWHub"
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            isNight: ThemeType.currentTheme().isDark,
            title: stringDefault(self.title, R.string.localizable.mainTabBarSetting()),
            repo: SubjectFactory.current(Repo.self)
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                //self.provider.repo(fullname: self.fullName).map(Mutation.setRepo).catchError({.just(.setError($0))}),
                .just(.setLoading(false))
            ])
        case .login:
            return .empty()
        case let .night(isNight):
            guard isNight != self.currentState.isNight else { return .empty() }
            return .just(.setNight(isNight))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setNight(isNight):
            state.isNight = isNight
        case let .setUser(user):
            var models: [[ModelType]] = []
            if let user = user {
                models.append([user/*, Setting(id: .logout, accessory: .none)*/])
            } else {
                models.append([Setting(id: .login)])
            }
//            if let repo = state.repo {
//                models.append([repo])
//            }
            let night = Setting(id: .night, accessory: .none, switched: ThemeType.currentTheme().isDark)
            let color = Setting(id: .color)
            let cache = Setting(id: .cache, accessory: .none)
            models.append([night, color, cache])
            state.user = user
            state.sections = self.sections(models)
        case let .start(sections):
            state.sections = self.sections(sections)
        case let .setRepo(repo):
            state.repo = repo
//            var sections = state.sections
//            if sections.count >= 3 {
//                sections.remove(at: 1)
//            }
//            sections.insert(.settings(header: R.string.localizable.settingProject(), items: [.project(SettingProjectItem(repo))]), at: 1)
//            state.sections = sections
//            Repo.update(repo)
        case let .setError(error):
            state.error = error
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(mutation, SubjectFactory.subject(User.self).asObservable().map(Mutation.setUser))
    }

    func sections(_ sections: [[ModelType]]) -> [SettingSection] {
        return sections.map { models -> SettingSection in
            var header = R.string.localizable.settingPreferences()
            var items: [SettingSectionItem] = []
            for model in models {
                if let user = model as? User {
                    header = R.string.localizable.settingAccount()
                    items.append(.profile(ProfileItem(user)))
                }
//                if let repository = model as? Repo {
//                    header = R.string.localizable.settingProject()
//                    items.append(.project(SettingProjectItem(repository)))
//                }
                if let setting = model as? Setting {
                    switch setting.id! {
                    case .login:
                        header = R.string.localizable.settingAccount()
                        items.append(.login(SettingLoginItem(setting)))
                    case .night:
                        items.append(.night(SettingSwitchItem(setting)))
                    case .color:
                        items.append(.color(SettingNormalItem(setting)))
                    case .cache:
                        items.append(.cache(SettingNormalItem(setting)))
                    default:
                        break
                    }
                }
            }
            return .settings(header: header, items: items)
        }
    }

}
