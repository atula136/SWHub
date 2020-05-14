//
//  UserSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/14.
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

enum UserSection {
    case list([UserSectionItem])
}

extension UserSection: SectionModelType {
    var items: [UserSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }

    init(original: UserSection, items: [UserSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum UserSectionItem {
    case detail(UserProfileItem)
}
