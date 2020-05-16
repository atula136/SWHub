//
//  Filter.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/16.
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
import RealmSwift
import Rswift
import SWFrame

//class Filter: Object, ModelType {
//
//    @objc dynamic var since = 0
//    @objc dynamic var language: Language?
//
//    required init() {
//    }
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        since       <- map["since"]
//        language    <- map["language"]
//    }
//
//    enum Since: Int, Codable {
//        case daily, weekly, monthly
//
//        static let allValues = [daily, weekly, monthly]
//
//        var title: String {
//            switch self {
//            case .daily: return R.string.localizable.daily()
//            case .weekly: return R.string.localizable.weekly()
//            case .monthly: return R.string.localizable.monthly()
//            }
//        }
//
//        var paramValue: String {
//            switch self {
//            case .daily: return "daily"
//            case .weekly: return "weekly"
//            case .monthly: return "monthly"
//            }
//        }
//
//    }
//
//}
