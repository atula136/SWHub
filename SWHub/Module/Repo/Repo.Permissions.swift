//
//  Repo.Permissions.swift
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

    class Permissions: Object, ModelType {

        @objc dynamic var admin = false
        @objc dynamic var push = false
        @objc dynamic var pull = false

        required init() {
        }

        required init?(map: Map) {
        }

        func mapping(map: Map) {
            admin                   <- map["admin"]
            push                    <- map["push"]
            pull                    <- map["pull"]
        }

    }

}
