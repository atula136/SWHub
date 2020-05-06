//
//  InfoItem.swift
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

class InfoItem: CollectionItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    enum Mutation {
        case setDark(Bool)
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
    
}

