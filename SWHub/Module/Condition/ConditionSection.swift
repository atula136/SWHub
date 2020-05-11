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
    case languages([ConditionSectionItem])
}

extension ConditionSection: SectionModelType {
    var items: [ConditionSectionItem] {
        switch self {
        case let .languages(items): return items
        }
    }

    init(original: ConditionSection, items: [ConditionSectionItem]) {
        switch original {
        case .languages: self = .languages(items)
        }
    }
}

enum ConditionSectionItem {
    case language(ConditionLanguageItem)
}
