//
//  Misc.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Misc: ModelType, Subjective2 {

    var id: Int?
    // var condition = Condition.init()

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        // condition   <- map["condition"]
    }

    static func objectStoreKey(id: String? = nil) -> String {
        return "Misc"
    }
}
