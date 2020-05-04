//
//  Misc.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Misc: ModelType, Subjective {
    
    var id: Int?
    var since = Condition.Since.daily
    var language: String?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        since       <- map["since"]
        language    <- map["language"]
    }
    
}
