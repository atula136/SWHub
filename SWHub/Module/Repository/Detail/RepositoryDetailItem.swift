//
//  RepositoryDetailItem.swift
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

class RepositoryDetailItem: NormalItem {
    required init(_ model: ModelType) {
        super.init(model)
        guard let model = model as? RepositoryDetailModel else { return }
        self.initialState = State(
            icon: model.key.image?.template,
            title: model.key.title,
            detail: model.detail?.attributedString(),
            accessory: .indicator
        )
    }
}
