//
//  ConditionSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import Kingfisher
import ObjectMapper
import SwifterSwift
import Rswift
import SWFrame

enum ConditionSection {
    case list([ConditionSectionItem])
}

extension ConditionSection: SectionModelType {
    var items: [ConditionSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }

    init(original: ConditionSection, items: [ConditionSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum ConditionSectionItem {
    case code(ConditionCodeItem)
}
