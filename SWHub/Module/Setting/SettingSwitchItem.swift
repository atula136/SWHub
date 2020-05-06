//
//  SettingSwitchItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SwifterSwift
import SWFrame

class SettingSwitchItem: DefaultItem, ReactorKit.Reactor {
    
    enum Action {
        case `switch`(Bool)
    }
    
    enum Mutation {
        case setSwitch(Bool)
    }
    
    struct State {
        var switched = false
        var icon: ImageSource?
        var title: String?
        var detail: NSAttributedString?
        var accessory = AccessoryType.indicator
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let setting = model as? Setting else { return }
        self.initialState = State(
            switched: setting.switched,
            icon: setting.icon,
            title: setting.title,
            detail: setting.detail,
            accessory: setting.accessory
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .switch(switched):
            guard switched != self.currentState.switched else { return .empty() }
            return .just(.setSwitch(switched))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setSwitch(switched):
            state.switched = switched
        }
        return state
    }
//
//    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let nightEvent = Setting.event.flatMap { event -> Observable<Mutation> in
//            switch event {
//            case let .dark(isDark):
//                return .just(.setDark(isDark))
//            }
//        }
//        return .merge(mutation, nightEvent)
//    }
//
//    func transform(state: Observable<State>) -> Observable<State> {
//        return state
//    }
    
}

