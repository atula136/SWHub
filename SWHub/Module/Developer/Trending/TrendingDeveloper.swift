//
//  TrendingDeveloper.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

struct TrendingDeveloper: ModelType, Storable {

    var id: Int?
    var name: String?
    var username: String?
    var url: URL?
    var avatar: URL?
    var href: URL?
    var repo: TrendingRepo?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name            <- map["name"]
        username        <- map["username"]
        url             <- (map["url"], URLTransform())
        avatar          <- (map["avatar"], URLTransform())
        href            <- (map["href"], URLTransform())
        repo            <- map["repo"]
    }

}
