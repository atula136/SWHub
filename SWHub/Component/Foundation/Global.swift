//
//  Global.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import KeychainAccess
import SWFrame

struct Global: ModelType, Subjective, Eventable {
    
    enum Event {
        case night(Bool)
    }
    
    var id: Int?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}
