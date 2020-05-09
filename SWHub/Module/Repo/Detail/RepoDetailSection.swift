//
//  RepoDetailSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
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

enum RepoDetailSection {
    case details([RepoDetailSectionItem])
}

extension RepoDetailSection: SectionModelType {
    var items: [RepoDetailSectionItem] {
        switch self {
        case let .details(items): return items
        }
    }

    init(original: RepoDetailSection, items: [RepoDetailSectionItem]) {
        switch original {
        case .details: self = .details(items)
        }
    }
}

enum RepoDetailSectionItem {
    case detail(RepoDetailItem)
}
