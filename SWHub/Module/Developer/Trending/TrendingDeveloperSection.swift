//
//  TrendingDeveloperSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

enum TrendingDeveloperSection {
    case developers([TrendingDeveloperSectionItem])
}

extension TrendingDeveloperSection: SectionModelType {
    var items: [TrendingDeveloperSectionItem] {
        switch self {
        case let .developers(items): return items
        }
    }
    
    init(original: TrendingDeveloperSection, items: [TrendingDeveloperSectionItem]) {
        switch original {
        case .developers: self = .developers(items)
        }
    }
}

enum TrendingDeveloperSectionItem {
    case developer(TrendingDeveloperItem)
}

