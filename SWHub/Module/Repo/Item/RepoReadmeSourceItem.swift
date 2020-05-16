//
//  RepoReadmeSourceItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class RepoReadmeSourceItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setDark(Bool)
    }

    struct State {
        var content: NSAttributedString?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let readme = model as? Repo.Readme else { return }
        self.initialState = State(
            content: readme.highlightedCode
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .night(isNight):
                return .just(.setDark(isNight))
            }
        }
        return .merge(mutation, nightEvent)
    }

//    func transform(state: Observable<State>) -> Observable<State> {
//        guard let repo = self.model as? TrendingRepo else { return state }
//        return state.flatMap { state -> Observable<State> in
//            var state = state
//            state.language = repo.languageText()
//            state.stars = repo.starsText()
//            state.forks = repo.forksText()
//            return .just(state)
//        }
//    }

}
