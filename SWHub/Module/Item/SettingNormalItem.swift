//
//  SettingNormalItem.swift
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
import SWFrame

class SettingNormalItem: NormalItem {

    required init(_ model: ModelType) {
        super.init(model)
        guard let setting = model as? Setting else { return }
        self.initialState = State(
            icon: setting.icon,
            title: setting.title,
            detail: setting.detail,
            accessory: setting.accessory
        )
    }

    override func transform(state: Observable<State>) -> Observable<State> {
        guard let setting = self.model as? Setting else { return state }
        switch setting.id! {
        case .cache:
            let update = ImageCache.default.rx.cacheSize().withLatestFrom(state) { size, state -> State in
                var state = state
                state.detail = size.byteText().styled(with: .alignment(.left))
                return state
            }
            return .merge(state, update)
        default:
            return state
        }
    }

}
