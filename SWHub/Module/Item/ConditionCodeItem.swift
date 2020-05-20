//
//  ConditionCodeItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import Kingfisher
import ObjectMapper
import SwifterSwift
import Rswift
import SWFrame

class ConditionCodeItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    enum Mutation {
        case setSelect(String?)
    }

    struct State {
        var checked = false
        var title: String?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let code = model as? Code else { return }
        self.initialState = State(
            // checked: code.checked,
            title: NSLocalizedString(code.id == nil ? Information.allLanguages : code.name ?? "", comment: "")
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setSelect(id):
            if let code = self.model as? Code {
                state.checked = id == code.id
            }
        }
        return state
    }

//    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let codeEvent = Code.event.flatMap { event -> Observable<Mutation> in
//            switch event {
//            case let .select(urlParam):
//                return .just(.setSelect(urlParam))
//            }
//        }
//        return .merge(mutation, codeEvent)
//    }

    func transform(state: Observable<State>) -> Observable<State> {
        guard let code = self.model as? Code else { return state }
        let update = Subjection.for(Code.self).withLatestFrom(state) { update, state -> State in
            var state = state
            state.checked = update?.id == code.id
            return state
        }
        return .merge(state, update)
    }

}
