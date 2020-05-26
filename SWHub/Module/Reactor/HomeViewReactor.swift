//
//  HomeViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import ReactorKit
import SWFrame

class HomeViewReactor: ScrollViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setLoading(Bool)
        case setCodes([Code])
    }

    struct State {
        var isLoading = false
        var title: String?
        var codes: [Code]?
        var items: [HomeKey] = [.repo, .user]
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.trending())
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                self.provider.codes().map { Mutation.setCodes($0) },
                .just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setCodes(codes):
            state.codes = codes
            let realm = Realm.default
            realm.beginWrite()
            realm.add(codes, update: .modified)
            try! realm.commitWrite()
        }
        return state
    }

}

enum HomeKey {
    case repo
    case user

    var title: String {
        switch self {
        case .repo:
            return R.string.localizable.repositories()
        case .user:
            return R.string.localizable.developers()
        }
    }
}
