//
//  TrendingUserSection.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

//import UIKit
//import RxSwift
//import RxCocoa
//import ReactorKit
//import RxDataSources
//
//enum TrendingUserSection {
//    case users([TrendingUserSectionItem])
//}
//
//extension TrendingUserSection: SectionModelType {
//    var items: [TrendingUserSectionItem] {
//        switch self {
//        case let .users(items): return items
//        }
//    }
//
//    init(original: TrendingUserSection, items: [TrendingUserSectionItem]) {
//        switch original {
//        case .users: self = .users(items)
//        }
//    }
//}
//
//enum TrendingUserSectionItem {
//    case user(UserBasicItem)
//}
