//
//  RepoSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
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

enum RepoSection {
    case list([RepoSectionItem])
}

extension RepoSection: SectionModelType {
    var items: [RepoSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }

    init(original: RepoSection, items: [RepoSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum RepoSectionItem {
    case readme(RepoReadmeItem)
}
