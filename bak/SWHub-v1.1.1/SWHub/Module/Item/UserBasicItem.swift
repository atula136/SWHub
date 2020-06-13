//
//  UserBasicItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/10.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class UserBasicItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setNight(Bool)
    }

    struct State {
        var name: String?
        var intro: String?
        var repo: NSAttributedString?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            name: user.username,
            intro: user.repo?.introduction,
            repo: user.repoText,
            avatar: user.avatar?.url
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        guard let user = self.model as? User else { return state }
        var state = state
        switch mutation {
        case .setNight:
            state.repo = user.repoText
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .turnNight(isNight):
                return .just(.setNight(isNight))
            default: return .empty()
            }
        }
        return .merge(mutation, nightEvent)
    }

}
