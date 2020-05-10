//
//  TrendingRepo.swift
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

struct TrendingRepo: ModelType, Storable {
    var id: Int?
    var stars: Int?
    var forks: Int?
    var currentPeriodStars: Int?
    var name: String?
    var author: String?
    var language: String?
    var languageColor: String?
    var description: String?
    var url: URL?
    var avatar: URL?
    var builtBy: [TrendingDeveloper]?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name                    <- map["name"]
        stars                   <- map["stars"]
        forks                   <- map["forks"]
        currentPeriodStars      <- map["currentPeriodStars"]
        author                  <- map["author"]
        language                <- map["language"]
        languageColor           <- map["languageColor"]
        description             <- map["description"]
        url                     <- (map["url"], URLTransform())
        avatar                  <- (map["avatar"], URLTransform())
        builtBy                 <- map["builtBy"]
    }

    func detail(since: String) -> NSAttributedString? {
        let starImage = FontAwesomeIcon.starIcon.image(ofSize: .s16, color: .text).styled(with: .baselineOffset(-3))
        let starsString = (self.stars ?? 0).kFormatted().styled(with: .color(.text))
        let currentPeriodStarsString = "\((self.currentPeriodStars ?? 0).kFormatted())\(since.lowercased())".styled(with: .color(.text))
        let languageColorShape = "●".styled(with: StringStyle([.color(self.languageColor?.color ?? .clear)]))
        let languageString = (self.language ?? "").styled(with: .color(.text))
        return .composed(of: [
            starImage, Special.space, starsString, Special.space, Special.tab,
            starImage, Special.space, currentPeriodStarsString, Special.space, Special.tab,
            languageColorShape, Special.space, languageString
        ])
    }
}
