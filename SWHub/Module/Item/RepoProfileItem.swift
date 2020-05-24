//
//  RepoProfileItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import ReactorKit
import Kingfisher
import SWFrame

class RepoProfileItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setNight(Bool)
    }

    struct State {
        var name: String?
        var detail: NSAttributedString?
        var counts: [NSAttributedString]?
        var lang: InfoModel?
        var issue: InfoModel?
        var request: InfoModel?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let repo = model as? Repo else { return }
        self.initialState = State(
            name: repo.fullName,
            detail: repo.detail,
            counts: repo.counts,
            lang: repo.langInfo,
            issue: repo.issueInfo,
            request: repo.requestInfo,
            avatar: repo.owner?.avatar?.url
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        guard let repo = self.model as? Repo else { return state }
        var state = state
        switch mutation {
        case .setNight:
            state.counts = repo.counts
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
