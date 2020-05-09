//
//  MyColorItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class MyColorItem: DefaultItem, ReactorKit.Reactor {

    enum AccessoryType: Equatable {
        case none
        case indicator
        case checkmark
        case switcher(Bool)

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none),
                 (.indicator, .indicator),
                 (.checkmark, .checkmark),
                 (.switcher, .switcher):
                return true
            default:
                return false
            }
        }
    }

    typealias Action = NoAction

    enum Mutation {
        case setColor(ColorTheme)
    }

    struct State {
        var icon: ImageSource?
        var title: String?
        var detail: NSAttributedString?
        var accessory = AccessoryType.indicator
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let color = model as? MyColor else { return }
        self.initialState = State(
            icon: UIImage(color: color.id!.color, size: CGSize(width: 50, height: 50)),
            title: color.id?.title,
            accessory: color.checked() ? AccessoryType.checkmark : AccessoryType.none
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setColor(colorTheme):
            if let color = self.model as? MyColor {
                if color.id! == colorTheme {
                    state.accessory = .checkmark
                } else {
                    state.accessory = .none
                }
            }
        }
        return state
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let colorEvent = MyColor.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .updateColor(colorTheme):
                return .just(.setColor(colorTheme))
            }
        }
        return .merge(mutation, colorEvent)
    }
}
