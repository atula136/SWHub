//
//  Config.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/17.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import Iconic
import RealmSwift
import ObjectMapper
import SWFrame

final class Config: Object, ModelType, Subjective {

    @objc dynamic var active = false
    @objc dynamic var since = 0
    @objc dynamic var codeId = ""
    @objc dynamic var userId: String?

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        since           <- map["since"]
        codeId          <- map["codeId"]
        userId          <- map["userId"]
    }

    static var current: Config? {
        let key = String(describing: self)
        if let subject = subjects[key] as? BehaviorRelay<Config?> {
            return subject.value
        }
        return Realm.default.objects(Config.self).filter("active = true").first
    }

}
