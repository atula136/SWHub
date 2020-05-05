//
//  TrendingRepositorySection.swift
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

enum TrendingRepositorySection {
    case repositories([TrendingRepositorySectionItem])
}

extension TrendingRepositorySection: SectionModelType {
    var items: [TrendingRepositorySectionItem] {
        switch self {
        case let .repositories(items): return items
        }
    }
    
    init(original: TrendingRepositorySection, items: [TrendingRepositorySectionItem]) {
        switch original {
        case .repositories: self = .repositories(items)
        }
    }
}

enum TrendingRepositorySectionItem {
    case repository(TrendingRepositoryItem)
}
