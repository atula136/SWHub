//
//  Repo.License.swift
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

class License: Object, ModelType {

    @objc dynamic var key: String?
    @objc dynamic var name: String?
    @objc dynamic var spdxId: String?
    @objc dynamic var url: String?
    @objc dynamic var nodeId: String?

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        key                     <- map["key"]
        name                    <- map["name"]
        spdxId                  <- map["spdx_id"]
        url                     <- map["url"]
        nodeId                  <- map["node_id"]
    }
}
