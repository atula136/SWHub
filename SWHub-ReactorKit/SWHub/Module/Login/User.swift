//
//  User.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import KeychainAccess
import SWFrame

struct User: ModelType, Storable, Subjective {
    
    fileprivate struct Key {
        static let token = "token"
    }
    
    fileprivate static let keychain = Keychain()
    static var token: String? {
        get { keychain[Key.token] }
        set { keychain[Key.token] = newValue }
    }
    
    var siteAdmin: Bool?
    var twoFactorAuthentication: Bool?
    var id: Int?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var following: Int?
    var privateGists: Int?
    var totalPrivateRepos: Int?
    var ownedPrivateRepos: Int?
    var diskUsage: Int?
    var collaborators: Int?
    var nodeId: String?
    var login: String?
    var type: String?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: String?
    var bio: String?
    var url: URL?
    var avatar: URL?
    var htmlUrl: URL?
    var followersUrl: URL?
    var followingUrl: URL?
    var gistsUrl: URL?
    var starredUrl: URL?
    var subscriptionsUrl: URL?
    var reposUrl: URL?
    var receivedEventsUrl: URL?
    var createdAt: Date?
    var updatedAt: Date?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        siteAdmin                       <- map["site_admin"]
        twoFactorAuthentication         <- map["two_factor_authentication"]
        id                              <- map["id"]
        publicRepos                     <- map["public_repos"]
        publicGists                     <- map["public_gists"]
        followers                       <- map["followers"]
        following                       <- map["following"]
        privateGists                    <- map["private_gists"]
        totalPrivateRepos               <- map["total_private_repos"]
        ownedPrivateRepos               <- map["owned_private_repos"]
        diskUsage                       <- map["disk_usage"]
        collaborators                   <- map["collaborators"]
        nodeId                          <- map["node_id"]
        login                           <- map["login"]
        type                            <- map["type"]
        name                            <- map["name"]
        company                         <- map["company"]
        blog                            <- map["blog"]
        location                        <- map["location"]
        email                           <- map["email"]
        hireable                        <- map["hireable"]
        bio                             <- map["bio"]
        url                             <- (map["url"], URLTransform())
        avatar                          <- (map["avatar_url"], URLTransform())
        htmlUrl                         <- (map["html_url"], URLTransform())
        followersUrl                    <- (map["followers_url"], URLTransform())
        followingUrl                    <- (map["following_url"], URLTransform())
        gistsUrl                        <- (map["gists_url"], URLTransform())
        starredUrl                      <- (map["starred_url"], URLTransform())
        subscriptionsUrl                <- (map["subscriptions_url"], URLTransform())
        reposUrl                        <- (map["repos_url"], URLTransform())
        receivedEventsUrl               <- (map["received_events_url"], URLTransform())
        createdAt                       <- (map["received_events_url"], CustomDateFormatTransform(formatString: "YYYY-MM-DD"))
        updatedAt                       <- (map["received_events_url"], CustomDateFormatTransform(formatString: "YYYY-MM-DD"))
    }
    
    func detail() -> NSAttributedString? {
        var texts = [NSAttributedString]()
        if let repositoriesString = self.publicRepos?.string.styled(with: .color(.text)) {
            let repositoriesImage = R.image.setting_badge_repository()?.filled(withColor: .text).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
            texts.append(.composed(of: [
                repositoriesImage, Special.space, repositoriesString, Special.space, Special.tab
            ]))
        }
        if let followersString = self.followers?.kFormatted().styled(with: .color(.text)) {
            let followersImage = R.image.setting_badge_collaborator()?.filled(withColor: .text).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
            texts.append(.composed(of: [
                followersImage, Special.space, followersString
            ]))
        }
        return .composed(of: texts)
    }
    
}
