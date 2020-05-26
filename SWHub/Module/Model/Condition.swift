//
//  Condition.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
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

struct Condition: ModelType, Eventable {

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
    }

    enum Event {
        case update(Since, Code)
    }

}

//struct Condition: ModelType, Subjective2, Equatable /*, Eventable */ {
//

//
//    var id: Int?
//    var since = Since.daily
//    var language = Language.init(name: "All languages")
//
//    init() {
//    }
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        since       <- map["since"]
//        language    <- map["language"]
//    }
//
//    static func objectStoreKey(id: String? = nil) -> String {
//        return "Condition"
//    }
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.since.rawValue == rhs.since.rawValue &&
//            lhs.language.urlParam == rhs.language.urlParam
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
//    struct Language: ModelType, Subjective2, Eventable, Equatable {
//
//        enum Event {
//            case select(String?)
//        }
//
//        var id: Int?
//        var checked = false
//        var name: String?
//        var urlParam: String?
//
//        init() {
//        }
//
//        init(name: String? = nil) {
//            self.name = name
//        }
//
//        init?(map: Map) {
//        }
//
//        mutating func mapping(map: Map) {
//            name            <- map["name"]
//            urlParam        <- map["urlParam"]
//        }
//
//        static func == (lhs: Self, rhs: Self) -> Bool {
//            return lhs.urlParam == rhs.urlParam
//        }
//
//        static func arrayStoreKey() -> String {
//            return "languages"
//        }
//    }
//}
