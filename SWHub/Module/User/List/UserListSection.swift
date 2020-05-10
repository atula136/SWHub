//
//  UserListSection.swift
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

enum UserListSection {
    case users([UserListSectionItem])
}

extension UserListSection: SectionModelType {
    var items: [UserListSectionItem] {
        switch self {
        case let .users(items): return items
        }
    }

    init(original: UserListSection, items: [UserListSectionItem]) {
        switch original {
        case .users: self = .users(items)
        }
    }
}

enum UserListSectionItem {
    case user(UserItem2)
}
