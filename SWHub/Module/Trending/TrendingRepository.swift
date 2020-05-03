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
    var languageColor: String? // YJX_TODO UIColor
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
    
}
