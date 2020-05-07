//
//  Starred.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

extension Repository {

    struct Starred: ModelType, Subjective {

        var id: Int?
        var message: String?
        var documentationUrl: String?

        init() {
        }

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            id                      <- map["id"]
            message                 <- map["message"]
            documentationUrl        <- map["documentation_url"]
        }
    }
}
