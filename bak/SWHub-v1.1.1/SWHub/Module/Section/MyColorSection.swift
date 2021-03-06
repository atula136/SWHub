//
//  TintSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum TintSection {
    case color([MyColorSectionItem])
}

extension TintSection: SectionModelType {

    var items: [MyColorSectionItem] {
        switch self {
        case let .color(items): return items
        }
    }

    init(original: TintSection, items: [MyColorSectionItem]) {
        switch original {
        case .color: self = .color(items)
        }
    }

}

enum MyColorSectionItem {
    case color(TintItem)
}
