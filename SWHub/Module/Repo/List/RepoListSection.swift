//
//  RepoListSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

enum RepoListSection {
    case repos([RepoListSectionItem])
}

extension RepoListSection: SectionModelType {
    var items: [RepoListSectionItem] {
        switch self {
        case let .repos(items): return items
        }
    }

    init(original: RepoListSection, items: [RepoListSectionItem]) {
        switch original {
        case .repos: self = .repos(items)
        }
    }
}

enum RepoListSectionItem {
    case repo(RepoBasicItem)
}
