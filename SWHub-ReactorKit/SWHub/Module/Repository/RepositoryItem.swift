//
//  RepositoryItem.swift
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
import SWFrame

class RepositoryItem: CollectionItem, ReactorKit.Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var title: String?
        var subtitle: String?
        var detail: NSAttributedString?
        var icon: URL?
    }
    
    var initialState = State()
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let repository = model as? Repository else { return }
        self.initialState = State(
            title: repository.fullName,
            subtitle: repository.description,
            detail: repository.detail(),
            icon: repository.owner?.avatar
        )
    }
    
}
