//
//  Links.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/16.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import RealmSwift
import ObjectMapper
import SWFrame

class Links: Object, ModelType {

    @objc dynamic var sef: String?
    @objc dynamic var git: String?
    @objc dynamic var html: String?

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        sef                     <- map["self"]
        git                     <- map["git"]
        html                    <- map["html"]
    }

}
