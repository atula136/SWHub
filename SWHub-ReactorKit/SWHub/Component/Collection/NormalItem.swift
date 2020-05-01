//
//  NormalItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SwifterSwift
import SWFrame

class NormalItem: CollectionItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var showIndicator = true
        var showSwitcher = false
        var switched = false
        var title: String?
        var detail: NSAttributedString?
        var icon: ImageSource?
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
    }
    
    func transform(state: Observable<State>) -> Observable<State> {
        return state
    }
    
}
