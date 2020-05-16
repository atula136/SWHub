//
//  Language.swift
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

class Code: Object, ModelType {

    @objc dynamic var name: String?
    @objc dynamic var urlParam: String?
    var checked = false

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name            <- map["name"]
        urlParam        <- map["urlParam"]
    }

//        static func == (lhs: Language, rhs: Language) -> Bool {
//            return lhs.urlParam == rhs.urlParam
//        }

}
