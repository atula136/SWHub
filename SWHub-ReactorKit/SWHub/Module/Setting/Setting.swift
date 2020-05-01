//
//  Setting.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Setting: ModelType, Identifiable {
    
    enum Category: Int, Codable {
        case user
        case logout
        //case theme
        
        enum CodingKeys: String, CodingKey {
            case user       = "user"
            case logout     = "logout"
            //case theme      = "theme"
        }
    }
    
    var id: Category?
    var title: String?
    var detail: NSAttributedString?
    var avatar: URL?
    
    init() {
        
    }
    
    init(id: Category, title: String? = nil) {
        self.id = id
        self.title = title
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        title       <- map["title"]
    }
    
}
