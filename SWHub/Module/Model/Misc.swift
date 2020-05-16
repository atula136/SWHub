//
//  Misc.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import RealmSwift
import ObjectMapper
import SWFrame

class Misc: Object, ModelType {

    @objc dynamic var since = 0
    @objc dynamic var code: Code?
    @objc dynamic var user: User?

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        since           <- map["since"]
        code            <- map["code"]
        user            <- map["user"]
    }

}

//struct Misc: ModelType, Subjective2 {
//
//    var id: Int?
//    // var condition = Condition.init()
//
//    init() {
//    }
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        // condition   <- map["condition"]
//    }
//
//    static func objectStoreKey(id: String? = nil) -> String {
//        return "Misc"
//    }
//}
