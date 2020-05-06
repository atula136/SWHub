//
//  NormalItem.swift
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

class NormalItem: DefaultItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var icon: ImageSource?
        var title: String?
        var detail: NSAttributedString?
        var accessory = AccessoryType.indicator
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        return state
    }
    
}
