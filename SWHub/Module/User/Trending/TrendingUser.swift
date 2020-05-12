//
//  TrendingUser.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import ObjectMapper
import SWFrame

struct TrendingUser: ModelType, Storable {

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

    func repoText() -> NSAttributedString? {
        var texts: [NSAttributedString] = []
        let string = (self.repo?.name ?? "").styled(with: .color(.textDark))
        let image = FontAwesomeIcon.bookIcon.image(ofSize: .s16, color: .textDark).styled(with: .baselineOffset(-3))
        texts.append(.composed(of: [
            image, Special.space, string
        ]))
        return .composed(of: texts)
    }

}
