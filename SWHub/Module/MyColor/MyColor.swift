//
//  MyColor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct MyColor: ModelType, Identifiable {
    
    var id: ColorTheme?
    
    init() {
    }
    
    init(id: ColorTheme) {
        self.id = id
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
    }
    
    func checked() -> Bool {
        return self.id! == ThemeType.colorTheme()
    }
    
}
