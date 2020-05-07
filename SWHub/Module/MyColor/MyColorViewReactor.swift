//
//  MyColorViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Rswift
import ReactorKit
import RxOptional
import SWFrame

class MyColorViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case initial([MyColor])
    }
    
    struct State {
        var isLoading = false
        var title: String?
        var sections: [MyColorSection] = []
    }
    
    var initialState = State()
    
    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.initialState = State(
            title: stringDefault(self.title, R.string.localizable.settingPreferencesTheme())
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                .just(.initial(ColorTheme.allValues.map{ MyColor(id: $0) })),
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .initial(colors):
            state.sections = [.color(colors.map{ MyColorItem($0) }.map{ MyColorSectionItem.color($0) })]
        }
        return state
    }
    
}
