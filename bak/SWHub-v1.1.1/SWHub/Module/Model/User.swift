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

final class User: Object, ModelType, Identifiable, Subjective {

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

//    var detail: NSAttributedString? {
//        var texts = [NSAttributedString]()
//        let repositoriesString = self.publicRepos.string.styled(with: .color(.title))
//        let repositoriesImage = FontAwesomeIcon.bookIcon.image(ofSize: .init(16), color: .tint).template.styled(with: .baselineOffset(-3))
//        texts.append(.composed(of: [
//            repositoriesImage, Special.space, repositoriesString, Special.space, Special.tab
//        ]))
//        let followersString = self.followers.kFormatted().styled(with: .color(.title))
//        let followersImage = FontAwesomeIcon.userIcon.image(ofSize: .init(16), color: .tint).template.styled(with: .baselineOffset(-3))
//        texts.append(.composed(of: [
//            followersImage, Special.space, followersString
//        ]))
//        return .composed(of: texts)
//    }

//    var detail: NSAttributedString? {
//        let name = (self.nickname ?? self.username)?.styled(with: .font(.bold(16)), .color(.title), .lineHeightMultiple(1.4)) ?? NSAttributedString()
//        let intro = self.bio?.styled(with: .font(.normal(13)), .color(.content), .lineSpacing(2)) ?? NSAttributedString()
//        let update = R.string.localizable.userJoinedDatetime(self.updatedAt?.string(withFormat: "yyyy-MM-dd") ?? "").styled(with: .font(.normal(12)), .color(.datetime), .lineHeightMultiple(1.2))
//        return .composed(of: [
//            name, Special.nextLine, intro, Special.nextLine, update
//        ])
//    }

    var counts: [NSAttributedString] {
        let repositories = self.count(title: R.string.localizable.repositories(), value: self.publicRepos + self.totalPrivateRepos)
        let followers = self.count(title: R.string.localizable.followers(), value: self.followers)
        let following = self.count(title: R.string.localizable.following(), value: self.following)
        return [repositories, followers, following]
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
        info.title = self.company
        info.indicated = false
        return info
    }

    var locationInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.globeIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.location
        info.indicated = false
        return info
    }

    var emailInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.inboxIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.email
        info.indicated = self.email != nil ? true : false
        return info
    }

    var blogInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon._581Icon.image(ofSize: .init(20), color: .tint).template
        info.title = self.blog
        info.indicated = self.blog != nil ? true : false
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

    override class func primaryKey() -> String? {
        return "id"
    }

    func count(title: String, value: Int) -> NSAttributedString {
        let valueText = value.string.styled(with: .color(.title), .font(.bold(17)), .alignment(.center))
        let titleText = title.styled(with: .color(.content), .font(.normal(13)), .alignment(.center))
        return .composed(of: [
            valueText, Special.nextLine, titleText
        ])
    }

    static var current: User? {
        let key = String(describing: self)
        if let subject = subjects[key] as? BehaviorRelay<User?> {
            return subject.value
        }
        let realm = Realm.default
        guard let id = realm.objects(Config.self).filter("active = true").first?.userId else { return nil }
        return realm.objects(User.self).filter("id = %@", id).first
    }

    class func login(_ user: User) {
        let realm = Realm.default
        let dft = Config()
        let old = Subjection.for(Config.self).value!
        var new = realm.objects(Config.self).filter("userId = %@", user.id).first
        realm.beginWrite()
        realm.add(user)
        realm.delete(old)
        realm.add(dft)
        if new != nil {
            new?.active = true
        } else {
            new = Config()
            new?.active = true
            new?.userId = user.id
            realm.add(new!)
        }
        try! realm.commitWrite()
        Subjection.for(User.self).accept(user)
        Subjection.for(Config.self).accept(new!)
        let since = Since(rawValue: new!.since) ?? Since.daily
        let code = Code(value: ["id": new!.codeId])
        Condition.event.onNext(.update(since, code))
    }

    class func logout() {
        let realm = Realm.default
        let user = Subjection.for(User.self).value!
        let old = Subjection.for(Config.self).value!
        let new = realm.objects(Config.self).filter("userId == nil").first!
        realm.beginWrite()
        realm.delete(user)
        old.active = false
        new.active = true
        try! realm.commitWrite()
        Subjection.for(User.self).accept(nil)
        Subjection.for(Config.self).accept(new)
        let since = Since(rawValue: new.since) ?? Since.daily
        let code = Code(value: ["id": new.codeId])
        Condition.event.onNext(.update(since, code))
    }

}
