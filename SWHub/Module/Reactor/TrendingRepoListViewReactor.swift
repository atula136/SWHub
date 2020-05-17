//
//  TrendingRepoListViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxRealm
import RealmSwift
import ReactorKit
import SWFrame

class TrendingRepoListViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
        case refresh
    }

    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setError(Error?)
        case setSince(Since)
        case setCode(Code)
        //case setCondition(Condition)
        case start([Repo])
    }

    struct State {
        var isLoading = false
        var isRefreshing = false
        var title: String?
        var error: Error?
        var since = Since.daily
        var code = Code(value: ["name": "All languages"])
        //var condition: Condition!
        var sections: [RepoSection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let realm = try! Realm()
        let misc = realm.objects(Misc.self).first
        var repos: [Repo] = []
        for repo in realm.objects(Repo.self).filter("#first = true") {
            repos.append(repo)
        }
        self.initialState = State(
            since: Since(rawValue: misc?.since ?? 0) ?? Since.daily,
            code: misc?.code ?? Code(value: ["name": "All languages"]),
            sections: [.list(repos.map { .basic(RepoBasicItem($0)) })]
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.provider.repos(language: self.currentState.code.urlParam, since: self.currentState.since.paramValue).map { Mutation.start($0) }.catchError { .just(.setError($0))},
                .just(.setLoading(false))
            ])
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setRefreshing(true)),
                self.provider.repos(language: self.currentState.code.urlParam, since: self.currentState.since.paramValue).map { Mutation.start($0) }.catchError { .just(.setError($0))},
                .just(.setRefreshing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        case let .setError(error):
            state.error = error
        case let .setSince(since):
            state.since = since
        case let .setCode(code):
            state.code = code
        case let .start(repos):
            Observable.collection(from: Realm.default.objects(User.self).filter("#first = true")).subscribe(Realm.rx.delete()).disposed(by: self.disposeBag)
            Observable.collection(from: Realm.default.objects(Repo.self).filter("#first = true")).subscribe(Realm.rx.delete()).disposed(by: self.disposeBag)
            let repos = repos.map { repo -> Repo in
                repo.first = true
                return repo
            }
            Observable.from(optional: repos).subscribe(Realm.rx.add()).disposed(by: self.disposeBag)
            state.sections = [.list(repos.map { .basic(RepoBasicItem($0)) })]
        }
        return state
    }
//
//    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        return .merge(
//            mutation,
//            Condition.subject().asObservable().filterNil().distinctUntilChanged().map(Mutation.setCondition)
//        )
//    }

}
