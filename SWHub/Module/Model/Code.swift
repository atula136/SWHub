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

final class Code: Object, ModelType, Subjective/*, Eventable*/ {

    static let `default` = Code()

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String?

    required init() {
        self.id = ""
        self.name = Information.allLanguages
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id              <- map["urlParam"]
        name            <- map["name"]
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    static var current: Code? {
        let key = String(describing: self)
        if let subject = subjects[key] as? BehaviorRelay<Code?> {
            return subject.value
        }
        let realm = Realm.default
        if let id = realm.objects(Config.self).filter("active = true").first?.codeId {
            return realm.objects(Code.self).filter("id = %@", id).first
        }
        return Code.default
    }

}
