//
//  Readme.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

extension Repository {
    
    struct Readme: ModelType, Subjective {
        
        var id: Int?
        var size: Int?
        var name: String?
        var path: String?
        var sha: String?
        var type: String?
        var encoding: String?
        var content: String?
        var url: String?
        var htmlUrl: String?
        var gitUrl: String?
        var downloadUrl: String?
        var links: Links?
        
        init() {
            
        }
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            id                      <- map["id"]
            size                    <- map["size"]
            name                    <- map["name"]
            path                    <- map["path"]
            sha                     <- map["sha"]
            type                    <- map["type"]
            encoding                <- map["encoding"]
            content                 <- map["content"]
            url                     <- map["url"]
            htmlUrl                 <- map["html_url"]
            gitUrl                  <- map["git_url"]
            downloadUrl             <- map["download_url"]
            links                   <- map["_links"]
        }
        
        struct Links: ModelType, Subjective {
            
            var id: Int?
            var `self`: String?
            var git: String?
            var html: String?
            
            init() {
                
            }
            
            init?(map: Map) {
                
            }
            
            mutating func mapping(map: Map) {
                id                      <- map["id"]
                `self`                  <- map["self"]
                git                     <- map["git"]
                html                    <- map["html"]
            }
            
        }
        
    }
    
}
