//
//  Developer.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

struct Developer: ModelType, Subjective {
    
    var siteAdmin = false
    var id: Int?
    var login: String?
    var nodeId: String?
    var gravatarId: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var eventsUrl: String?
    var type: String?
    var avatarUrl: URL?
    var url: URL?
    var htmlUrl: URL?
    var followersUrl: URL?
    var subscriptionsUrl: URL?
    var organizationsUrl: URL?
    var reposUrl: URL?
    var receivedEventsUrl: URL?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        siteAdmin                   <- map["site_admin"]
        id                          <- map["id"]
        login                       <- map["login"]
        nodeId                      <- map["node_id"]
        gravatarId                  <- map["gravatar_id"]
        followingUrl                <- map["following_url"]
        gistsUrl                    <- map["gists_url"]
        starredUrl                  <- map["starred_url"]
        eventsUrl                   <- map["events_url"]
        type                        <- map["type"]
        avatarUrl                   <- (map["avatar_url"], URLTransform())
        url                         <- (map["url"], URLTransform())
        htmlUrl                     <- (map["html_url"], URLTransform())
        followersUrl                <- (map["followers_url"], URLTransform())
        subscriptionsUrl            <- (map["subscriptions_url"], URLTransform())
        organizationsUrl            <- (map["organizations_url"], URLTransform())
        reposUrl                    <- (map["repos_url"], URLTransform())
        receivedEventsUrl           <- (map["received_events_url"], URLTransform())
    }
    
    
}

extension Developer: Eventable {
    
    enum Event {
        
    }
    
}
