//
//  ConditionLanguageItem.swift
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

class ConditionLanguageItem: CollectionItem, ReactorKit.Reactor {

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
        guard let language = model as? Condition.Language else { return }
        self.initialState = State(
            checked: language.checked,
            title: language.urlParam == nil ? NSLocalizedString(language.name ?? R.string.localizable.allLanguages(), comment: "") : language.name
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setSelect(urlParam):
            if let language = self.model as? Condition.Language {
                state.checked = urlParam == language.urlParam
            }
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let languageSelectEvent = Condition.Language.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .select(urlParam):
                return .just(.setSelect(urlParam))
            }
        }
        return .merge(mutation, languageSelectEvent)
    }
}
