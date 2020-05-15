//
//  RepoDetailSection2.swift
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

enum RepoDetailSection2 {
    case details([RepoDetailSectionItem2])
}

extension RepoDetailSection2: SectionModelType {
    var items: [RepoDetailSectionItem2] {
        switch self {
        case let .details(items): return items
        }
    }

    init(original: RepoDetailSection2, items: [RepoDetailSectionItem2]) {
        switch original {
        case .details: self = .details(items)
        }
    }
}

enum RepoDetailSectionItem2 {
    case detail(RepoDetailItem2)
}
