//
//  User.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct User: ModelType, Storable, Subjective {
    
    var id = 0
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
    }
    
}
