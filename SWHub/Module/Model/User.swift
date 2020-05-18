//
//  User.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/16.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import ObjectMapper
import RxSwift
import RxCocoa
import RealmSwift
import KeychainAccess
import SWFrame

class User: Object, ModelType, Identifiable {

    fileprivate struct Key {
        static let token = "token"
    }

    static var token: String? {
        get { Keychain.shared[Key.token] }
        set { Keychain.shared[Key.token] = newValue }
    }

    @objc dynamic var first = false
    @objc dynamic var siteAdmin = false
    @objc dynamic var twoFactorAuthentication = false
    @objc dynamic var publicRepos = 0
    @objc dynamic var publicGists = 0
    @objc dynamic var followers = 0
    @objc dynamic var following = 0
    @objc dynamic var privateGists = 0
    @objc dynamic var totalPrivateRepos = 0
    @objc dynamic var ownedPrivateRepos = 0
    @objc dynamic var diskUsage = 0
    @objc dynamic var collaborators = 0
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var nodeId: String?
    @objc dynamic var username: String?
    @objc dynamic var nickname: String?
    @objc dynamic var type: String?
    @objc dynamic var company: String?
    @objc dynamic var blog: String?
    @objc dynamic var location: String?
    @objc dynamic var email: String?
    @objc dynamic var hireable: String?
    @objc dynamic var bio: String?
    @objc dynamic var gravatarId: String?
    @objc dynamic var url: String?
    @objc dynamic var href: String?
    @objc dynamic var avatar: String?
    @objc dynamic var htmlUrl: String?
    @objc dynamic var followersUrl: String?
    @objc dynamic var followingUrl: String?
    @objc dynamic var gistsUrl: String?
    @objc dynamic var starredUrl: String?
    @objc dynamic var subscriptionsUrl: String?
    @objc dynamic var reposUrl: String?
    @objc dynamic var eventsUrl: String?
    @objc dynamic var organizationsUrl: String?
    @objc dynamic var receivedEventsUrl: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var repo: Repo?

    var detail: NSAttributedString? {
        var texts = [NSAttributedString]()
        let repositoriesString = self.publicRepos.string.styled(with: .color(.title))
        let repositoriesImage = FontAwesomeIcon.bookIcon.image(ofSize: .init(16), color: .tint).template.styled(with: .baselineOffset(-3))
        texts.append(.composed(of: [
            repositoriesImage, Special.space, repositoriesString, Special.space, Special.tab
        ]))
        let followersString = self.followers.kFormatted().styled(with: .color(.title))
        let followersImage = FontAwesomeIcon.userIcon.image(ofSize: .init(16), color: .tint).template.styled(with: .baselineOffset(-3))
        texts.append(.composed(of: [
            followersImage, Special.space, followersString
        ]))
        return .composed(of: texts)
    }

    var repoText: NSAttributedString? {
        var texts: [NSAttributedString] = []
        let string = (self.repo?.name ?? "").styled(with: .color(.title))
        let image = FontAwesomeIcon.bookIcon.image(ofSize: .init(16), color: .title).styled(with: .baselineOffset(-3))
        texts.append(.composed(of: [
            image, Special.space, string
        ]))
        return .composed(of: texts)
    }

    var companyInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.userIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.company ?? R.string.localizable.company()
        info.indicated = false
        info.enabled = self.company != nil ? true : false
        return info
    }

    var locationInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.globeIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.location ?? R.string.localizable.location()
        info.indicated = false
        info.enabled = self.location != nil ? true : false
        return info
    }

    var emailInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.inboxIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.email ?? R.string.localizable.email()
        info.indicated = self.email != nil ? true : false
        info.enabled = self.email != nil ? true : false
        return info
    }

    var blogInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon._581Icon.image(ofSize: .init(20), color: .tint).template
        info.title = self.blog ?? R.string.localizable.blog()
        info.indicated = self.blog != nil ? true : false
        info.enabled = self.blog != nil ? true : false
        return info
    }

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        first                           <- map["first"]
        siteAdmin                       <- map["site_admin"]
        twoFactorAuthentication         <- map["two_factor_authentication"]
        id                              <- (map["id"], StringTransform())
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
        username                        <- map["login"]
        nickname                        <- map["name"]
        type                            <- map["type"]
        company                         <- map["company"]
        blog                            <- map["blog"]
        location                        <- map["location"]
        email                           <- map["email"]
        hireable                        <- map["hireable"]
        bio                             <- map["bio"]
        gravatarId                      <- map["gravatar_id"]
        url                             <- map["url"]
        href                            <- map["href"]
        avatar                          <- map["avatar_url"]
        htmlUrl                         <- map["html_url"]
        followersUrl                    <- map["followers_url"]
        followingUrl                    <- map["following_url"]
        gistsUrl                        <- map["gists_url"]
        starredUrl                      <- map["starred_url"]
        subscriptionsUrl                <- map["subscriptions_url"]
        reposUrl                        <- map["repos_url"]
        eventsUrl                       <- map["events_url"]
        organizationsUrl                <- map["organizations_url"]
        receivedEventsUrl               <- map["received_events_url"]
        createdAt                       <- (map["created_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        updatedAt                       <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        repo                            <- map["repo"]
        if username == nil {
            username                    <- map["username"]
        }
        if avatar == nil {
            avatar                      <- map["avatar"]
        }
    }

    func count(title: String, value: Int) -> NSAttributedString {
        let valueText = value.string.styled(with: .color(.tint), .font(.bold(17)), .alignment(.center))
        let titleText = title.styled(with: .color(.title), .font(.normal(13)), .alignment(.center))
        return .composed(of: [
            valueText, Special.nextLine, titleText
        ])
    }

    static var current: BehaviorRelay<User?> {
        let key = String(describing: self)
        if let subject = subjects[key] as? BehaviorRelay<User?> {
            return subject
        }
        // let subject = BehaviorRelay<User?>(value: Realm.default.objects(Config.self).first?.user)
        let subject = BehaviorRelay<User?>(value: nil) // TODO
        subjects[key] = subject
        return subject
    }

}
