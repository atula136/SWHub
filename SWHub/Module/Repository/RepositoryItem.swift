//
//  RepositoryItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class RepositoryItem: CollectionItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    enum Mutation {
        case setNight(Bool)
    }
    
    struct State {
        var title: String?
        var subtitle: String?
        var detail: NSAttributedString?
        var icon: URL?
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
//        if let repository = model as? GithubRepository {
//            self.initialState = State(
//                title: repository.fullName,
//                subtitle: repository.description,
//                detail: repository.detail(),
//                icon: repository.owner?.avatar
//            )
//        }
//        if let repository = model as? TrendingRepository {
//            self.initialState = State(
//                title: "\(repository.author ?? "")/\(repository.name ?? "")",
//                subtitle: repository.description,
//                detail: repository.detail(),
//                icon: repository.avatar
//            )
//        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//        switch mutation {
//        case .setNight(_):
//            if let repository = self.model as? GithubRepository {
//                state.detail = repository.detail()
//            }
//            if let repository = self.model as? TrendingRepository {
//                state.detail = repository.detail()
//            }
//        }
//        return state
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .night(isDark):
                return .just(.setNight(isDark))
            }
        }
        return .merge(mutation, nightEvent)
    }
    
}
