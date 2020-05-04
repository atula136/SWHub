//
//  TrendingRepository.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

struct TrendingRepository: ModelType, Storable {
    
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
//        name                    = try? map.value("name")
//        stars                   = try? map.value("stars")
//        forks                   = try? map.value("forks")
//        currentPeriodStars      = try? map.value("currentPeriodStars")
//        author                  = try? map.value("author")
//        language                = try? map.value("language")
//        languageColor           = try? map.value("languageColor")
//        description             = try? map.value("description")
//        url                     = try? map.value("url", using: URLTransform())
//        avatar                  = try? map.value("avatar", using: URLTransform())
//        builtBy                 = try? map.value("builtBy")
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
    
    func detail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []
        let starsString = (self.stars ?? 0).kFormatted().styled(with: .color(.text))
        let starsImage = R.image.setting_badge_star()?.filled(withColor: .text).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        texts.append(.composed(of: [
            starsImage, Special.space, starsString, Special.space, Special.tab
        ]))

        if let languageString = self.language?.styled(with: .color(.text)) {
            let languageColorShape = "●".styled(with: StringStyle([.color(self.languageColor?.color ?? .clear)]))
            texts.append(.composed(of: [
                languageColorShape, Special.space, languageString
            ]))
        }

        return .composed(of: texts)
    }
    
}
