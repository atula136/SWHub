//
//  Repo.Starred.swift
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

extension Repo {

    class Starred: Object, ModelType {

        @objc dynamic var message: String?
        @objc dynamic var documentationUrl: String?

        required init() {
        }

        required init?(map: Map) {
        }

        func mapping(map: Map) {
            message                 <- map["message"]
            documentationUrl        <- map["documentation_url"]
        }

    }

}
