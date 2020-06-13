//
//  UserProfileItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/14.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import ReactorKit
import Kingfisher
import SWFrame

class UserProfileItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setNight(Bool)
    }

    struct State {
        var name: String?
        var intro: String?
        var time: String?
        var counts: [NSAttributedString]?
        var company: InfoModel?
        var location: InfoModel?
        var email: InfoModel?
        var blog: InfoModel?
        var avatar: URL?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let user = model as? User else { return }
        self.initialState = State(
            name: user.nickname ?? user.username,
            intro: user.bio ?? R.string.localizable.noPersonalIntroduction(),
            time: R.string.localizable.userJoinedDatetime(user.updatedAt?.string(withFormat: "yyyy-MM-dd") ?? ""),
            counts: user.counts,
            company: user.companyInfo,
            location: user.locationInfo,
            email: user.emailInfo,
            blog: user.blogInfo,
            avatar: user.avatar?.url
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        guard let user = self.model as? User else { return state }
        var state = state
        switch mutation {
        case .setNight:
            state.counts = user.counts
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
