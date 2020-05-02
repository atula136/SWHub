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

class NormalItem: DefaultCollectionItem, ReactorKit.Reactor {
    
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
