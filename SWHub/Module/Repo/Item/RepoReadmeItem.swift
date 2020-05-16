//
//  RepoReadmeItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class RepoReadmeItem: CollectionItem, ReactorKit.Reactor {

    typealias Action = NoAction

    struct State {
        var markdown: String?
    }

    var initialState = State()

    required init(_ model: ModelType) {
        super.init(model)
        guard let readme = model as? Repo.Readme else { return }
        self.initialState = State(
            markdown: readme.markdown
        )
    }

}
