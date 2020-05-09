//
//  TrendingRepoSection.swift
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

enum TrendingRepoSection {
    case repositories([TrendingRepoSectionItem])
}

extension TrendingRepoSection: SectionModelType {
    var items: [TrendingRepoSectionItem] {
        switch self {
        case let .repositories(items): return items
        }
    }

    init(original: TrendingRepoSection, items: [TrendingRepoSectionItem]) {
        switch original {
        case .repositories: self = .repositories(items)
        }
    }
}

enum TrendingRepoSectionItem {
    case repository(RepoItem)
}
