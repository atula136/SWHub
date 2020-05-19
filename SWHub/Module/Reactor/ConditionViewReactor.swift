//
//  ConditionViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import ReactorKit
import SWFrame

class ConditionViewReactor: CollectionViewReactor, ReactorKit.Reactor {
    enum Action {
        case since(Int)         // TODO Home中请求code，每启动一次app更新一次，节省流量
        case code(String?)
    }
    enum Mutation {
        case setError(Error?)
        case setSince(Int)
        case setCode(String?)
    }

    struct State {
        var error: Error?
        var since = Since.daily
        var code = Code()
        var sections: [ConditionSection] = []
    }

    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        let realm = Realm.default
        let config = Subjection.for(Config.self).value ?? Config()
        // since
        let value = stringMember(self.parameters, Parameter.since, config.since.string)!
        let since = Since(rawValue: value.int ?? 0) ?? Since.daily
        // code
        let id = stringMember(self.parameters, Parameter.code, config.codeId)
        let code = Code(value: ["id": id])
        // sections
        var sectionItems: [ConditionSectionItem] = []
        let codes = realm.objects(Code.self)
        for model in codes {
            sectionItems.append(.code(ConditionCodeItem(model)))
        }
        // setting
        Subjection.for(Code.self).accept(code)
        let sections: [ConditionSection] = [.list(sectionItems)]
        self.initialState = State(
            since: since,
            code: code,
            sections: sections
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .since(value):
            guard value != self.currentState.since.rawValue else { return .empty() }
            return .just(.setSince(value))
        case let .code(id):
            guard id != self.currentState.code.id else { return .empty() }
            return .just(.setCode(id))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setError(error):
            state.error = error
        case let .setSince(value):
            guard let since = Since(rawValue: value) else { return state }
            state.since = since
        case let .setCode(id):
            state.code = Code(value: ["id": id])
        }
        return state
    }

}
