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
import RealmSwift
import ReactorKit
import RxOptional
import SWFrame

class SettingViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case night(Bool)
    }

    enum Mutation {
        case setLoading(Bool)
        case setNight(Bool)
        case setError(Error?)
        case setUser(User?)
    }

    struct State {
        var isLoading = false
        var isNight = false
        var title: String?
        var error: Error?
        var user: User?
        var sections: [SettingSection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            isNight: ThemeType.currentTheme().isDark,
            title: stringDefault(self.title, R.string.localizable.setting())
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let username = self.currentState.user?.username else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                self.provider.user(username: username).do(onNext: { user in
                    let realm = Realm.default
                    realm.beginWrite()
                    realm.add(user, update: .modified)
                    try! realm.commitWrite()
                    Subjection.for(User.self).accept(user)
                }).flatMap({ _ in Observable.empty() }).catchError({.just(.setError($0))}),
                .just(.setLoading(false))
            ])
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
                models.append([user])
            } else {
                models.append([Setting(id: .login)])
            }
            let night = Setting(id: .night, accessory: .none, switched: ThemeType.currentTheme().isDark)
            let color = Setting(id: .color)
            let cache = Setting(id: .cache, accessory: .none)
            models.append([night, color, cache])
            state.user = user
            state.sections = self.sections(models)
        case let .setError(error):
            state.error = error
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(mutation, Subjection.for(User.self).asObservable().map(Mutation.setUser))
    }

    func sections(_ sections: [[ModelType]]) -> [SettingSection] {
        return sections.map { models -> SettingSection in
            var items: [SettingSectionItem] = []
            for model in models {
                if let user = model as? User {
                    items.append(.profile(UserProfileItem(user)))
                }
                if let setting = model as? Setting {
                    switch setting.id! {
                    case .login:
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
            return .list(items)
        }
    }

}
