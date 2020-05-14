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
    case repos([TrendingRepoSectionItem])
}

extension TrendingRepoSection: SectionModelType {
    var items: [TrendingRepoSectionItem] {
        switch self {
        case let .repos(items): return items
        }
    }

    init(original: TrendingRepoSection, items: [TrendingRepoSectionItem]) {
        switch original {
        case .repos: self = .repos(items)
        }
    }
}

enum TrendingRepoSectionItem {
    case repo(RepoBasicItem)
}
