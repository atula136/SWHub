//
//  Repo.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import RealmSwift
import SwiftDate
import ObjectMapper
import ObjectMapper_Realm
import SWFrame

class Repo: Object, ModelType, Identifiable, Eventable {

    @objc dynamic var first = false
    @objc dynamic var `private` = false
    @objc dynamic var fork = false
    @objc dynamic var hasIssues = false
    @objc dynamic var hasProjects = false
    @objc dynamic var hasDownloads = false
    @objc dynamic var hasWiki = false
    @objc dynamic var hasPages = false
    @objc dynamic var archived = false
    @objc dynamic var disabled = false
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var size = 0
    @objc dynamic var stargazersCount = 0
    @objc dynamic var watchersCount = 0
    @objc dynamic var forksCount = 0
    @objc dynamic var openIssuesCount = 0
    @objc dynamic var openIssues = 0
    @objc dynamic var watchers = 0
    @objc dynamic var networkCount = 0
    @objc dynamic var subscribersCount = 0
    @objc dynamic var currentPeriodStars = 0
    @objc dynamic var nodeId: String?
    @objc dynamic var name: String?
    @objc dynamic var author: String?
    @objc dynamic var avatar: String?
    @objc dynamic var fullName: String?
    @objc dynamic var introduction: String?
    @objc dynamic var language: String?
    @objc dynamic var languageColor: String?
    @objc dynamic var defaultBranch: String?
    @objc dynamic var tempCloneToken: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var pushedAt: String?
    @objc dynamic var homepage: String?
    @objc dynamic var gitUrl: String?
    @objc dynamic var sshUrl: String?
    @objc dynamic var cloneUrl: String?
    @objc dynamic var svnUrl: String?
    @objc dynamic var mirrorUrl: String?
    @objc dynamic var htmlUrl: String?
    @objc dynamic var url: String?
    @objc dynamic var forksUrl: String?
    @objc dynamic var keysUrl: String?
    @objc dynamic var collaboratorsUrl: String?
    @objc dynamic var teamsUrl: String?
    @objc dynamic var hooksUrl: String?
    @objc dynamic var issueEventsUrl: String?
    @objc dynamic var eventsUrl: String?
    @objc dynamic var assigneesUrl: String?
    @objc dynamic var branchesUrl: String?
    @objc dynamic var tagsUrl: String?
    @objc dynamic var blobsUrl: String?
    @objc dynamic var gitTagsUrl: String?
    @objc dynamic var gitRefsUrl: String?
    @objc dynamic var treesUrl: String?
    @objc dynamic var statusesUrl: String?
    @objc dynamic var languagesUrl: String?
    @objc dynamic var stargazersUrl: String?
    @objc dynamic var contributorsUrl: String?
    @objc dynamic var subscribersUrl: String?
    @objc dynamic var subscriptionUrl: String?
    @objc dynamic var commitsUrl: String?
    @objc dynamic var gitCommitsUrl: String?
    @objc dynamic var commentsUrl: String?
    @objc dynamic var issueCommentUrl: String?
    @objc dynamic var contentsUrl: String?
    @objc dynamic var compareUrl: String?
    @objc dynamic var mergesUrl: String?
    @objc dynamic var archiveUrl: String?
    @objc dynamic var downloadsUrl: String?
    @objc dynamic var issuesUrl: String?
    @objc dynamic var pullsUrl: String?
    @objc dynamic var milestonesUrl: String?
    @objc dynamic var notificationsUrl: String?
    @objc dynamic var labelsUrl: String?
    @objc dynamic var releasesUrl: String?
    @objc dynamic var deploymentsUrl: String?
    @objc dynamic var license: License?
    @objc dynamic var permissions: Permissions?
    @objc dynamic var owner: User?
    var builtBy = RealmSwift.List<User>()

    var languageText: NSAttributedString? {
        var texts: [NSAttributedString] = []
        let shape = "●".styled(with: StringStyle([.color(self.languageColor?.color ?? .random)]))
        let string = (self.language ?? R.string.localizable.none()).styled(with: .color(.title))
        texts.append(.composed(of: [
            shape, Special.space, string
        ]))
        return .composed(of: texts)
    }

    var basic: NSAttributedString? {
          var texts: [NSAttributedString] = []
          let starsString = self.stargazersCount.kFormatted().styled(with: .color(.title))
          let starsImage = FontAwesomeIcon.starIcon.image(ofSize: .init(16), color: .tint).styled(with: .baselineOffset(-3))
          texts.append(.composed(of: [
              starsImage, Special.space, starsString, Special.space, Special.tab
          ]))

          if let languageString = self.language?.styled(with: .color(.title)) {
      //            let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(hexString: /*self.languageColor ?? */"") ?? .clear)]))
              let languageColorShape = "●".styled(with: StringStyle([.color(.clear)]))
              texts.append(.composed(of: [
                  languageColorShape, Special.space, languageString
              ]))
          }
          return .composed(of: texts)
      }

      var starsText: NSAttributedString? {
          var texts: [NSAttributedString] = []
          let string = self.stargazersCount.kFormatted().styled(with: .color(.title))
          let image = FontAwesomeIcon.starIcon.image(ofSize: .init(16), color: .tint).styled(with: .baselineOffset(-3))
          texts.append(.composed(of: [
              image, Special.space, string
          ]))
          return .composed(of: texts)
      }

    var forksText: NSAttributedString? {
        var texts: [NSAttributedString] = []
        let string = self.forksCount.kFormatted().styled(with: .color(.title))
        let image = FontAwesomeIcon.codeForkIcon.image(ofSize: .init(16), color: .title).styled(with: .baselineOffset(-3))
        texts.append(.composed(of: [
            image, Special.space, string
        ]))
        return .composed(of: texts)
    }

    var detail: NSAttributedString? {
        let description = self.introduction?.styled(with: .font(.normal(13)), .color(.content), .lineSpacing(2)) ?? NSAttributedString()
        let homepage = self.homepage?.styled(with: .font(.normal(12)), .color(.tint), .link(self.homepage?.url ?? URL(string: "http://m.baidu.com")!)) ?? NSAttributedString()
        let update = R.string.localizable.repoUpdateDatetime(self.updatedAt?.toRelative(since: nil, style: nil, locale: Locales.english) ?? "").styled(with: .font(.normal(12)), .color(.datetime), .lineHeightMultiple(1.2))
        return .composed(of: [
            description, Special.nextLine, homepage, Special.lineSeparator, update
        ])
    }

      var counts: [NSAttributedString] {
          let watchs = self.count(title: R.string.localizable.watchs(), value: self.subscribersCount)
          let stars = self.count(title: R.string.localizable.stars(), value: self.stargazersCount)
          let forks = self.count(title: R.string.localizable.forks(), value: self.forksCount)
          return [watchs, stars, forks]
      }

    var langInfo: InfoModel {
        var info = InfoModel.init()
        info.icon = FontAwesomeIcon.codeIcon.image(ofSize: .init(20), color: .tint).template
        info.title = self.language
        info.detail = self.size.byteText()
        info.indicated = true
        return info
    }

      var issueInfo: InfoModel {
          var info = InfoModel.init()
          info.icon = FontAwesomeIcon._627Icon.image(ofSize: .init(20), color: .tint).template
          info.title = R.string.localizable.issues()
          info.detail = self.openIssues.string
          info.indicated = true
          return info
      }

      var requestInfo: InfoModel {
          var info = InfoModel.init()
          info.icon = FontAwesomeIcon.codeForkIcon.image(ofSize: .init(20), color: .tint).template
          info.title = R.string.localizable.pullRequests()
          info.indicated = true
          return info
      }

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        first                       <- map["first"]
        `private`                   <- map["private"]
        fork                        <- map["fork"]
        hasIssues                   <- map["has_issues"]
        hasProjects                 <- map["has_projects"]
        hasDownloads                <- map["has_downloads"]
        hasWiki                     <- map["has_wiki"]
        hasPages                    <- map["has_pages"]
        archived                    <- map["archived"]
        disabled                    <- map["disabled"]
        id                          <- (map["id"], StringTransform())
        size                        <- map["size"]
        stargazersCount             <- map["stargazers_count"]
        watchersCount               <- map["watchers_count"]
        forksCount                  <- map["forks_count"]
        openIssuesCount             <- map["open_issues_count"]
        currentPeriodStars          <- map["currentPeriodStars"]
        openIssues                  <- map["open_issues"]
        watchers                    <- map["watchers"]
        networkCount                <- map["network_count"]
        subscribersCount            <- map["subscribers_count"]
        nodeId                      <- map["node_id"]
        name                        <- map["name"]
        author                      <- map["author"]
        avatar                      <- map["avatar"]
        fullName                    <- map["full_name"]
        introduction                <- map["description"]
        language                    <- map["language"]
        languageColor               <- map["languageColor"]
        defaultBranch               <- map["default_branch"]
        tempCloneToken              <- map["temp_clone_token"]
        createdAt                   <- map["created_at"]
        pushedAt                    <- map["pushed_at"]
        homepage                    <- map["homepage"]
        gitUrl                      <- map["git_url"]
        sshUrl                      <- map["ssh_url"]
        cloneUrl                    <- map["clone_url"]
        svnUrl                      <- map["svn_url"]
        mirrorUrl                   <- map["mirror_url"]
        htmlUrl                     <- map["html_url"]
        url                         <- map["url"]
        forksUrl                    <- map["forks_url"]
        keysUrl                     <- map["keys_url"]
        collaboratorsUrl            <- map["collaborators_url"]
        teamsUrl                    <- map["teams_url"]
        hooksUrl                    <- map["hooks_url"]
        issueEventsUrl              <- map["issue_events_url"]
        eventsUrl                   <- map["events_url"]
        assigneesUrl                <- map["assignees_url"]
        branchesUrl                 <- map["branches_url"]
        tagsUrl                     <- map["tags_url"]
        blobsUrl                    <- map["blobs_url"]
        gitTagsUrl                  <- map["git_tags_url"]
        gitRefsUrl                  <- map["git_refs_url"]
        treesUrl                    <- map["trees_url"]
        statusesUrl                 <- map["statuses_url"]
        languagesUrl                <- map["languages_url"]
        stargazersUrl               <- map["stargazers_url"]
        contributorsUrl             <- map["contributors_url"]
        subscribersUrl              <- map["subscribers_url"]
        subscriptionUrl             <- map["subscription_url"]
        commitsUrl                  <- map["commits_url"]
        gitCommitsUrl               <- map["git_commits_url"]
        commentsUrl                 <- map["comments_url"]
        issueCommentUrl             <- map["issue_comment_url"]
        contentsUrl                 <- map["contents_url"]
        compareUrl                  <- map["compare_url"]
        mergesUrl                   <- map["merges_url"]
        archiveUrl                  <- map["archive_url"]
        downloadsUrl                <- map["downloads_url"]
        issuesUrl                   <- map["issues_url"]
        pullsUrl                    <- map["pulls_url"]
        milestonesUrl               <- map["milestones_url"]
        notificationsUrl            <- map["notifications_url"]
        labelsUrl                   <- map["labels_url"]
        releasesUrl                 <- map["releases_url"]
        deploymentsUrl              <- map["deployments_url"]
        license                     <- map["license"]
        permissions                 <- map["permissions"]
        owner                       <- map["owner"]
        builtBy                     <- (map["builtBy"], ListTransform<User>())
        updatedAt                   <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        if stargazersCount == 0 {
            stargazersCount         <- map["stars"]
        }
        if forksCount == 0 {
            forksCount              <- map["forks"]
        }
    }

    func count(title: String, value: Int) -> NSAttributedString {
        let valueText = value.string.styled(with: .color(.title), .font(.bold(16)), .alignment(.center))
        let titleText = title.styled(with: .color(.content), .font(.normal(14)), .alignment(.center))
        return .composed(of: [
            valueText, Special.nextLine, titleText
        ])
    }

    override class func ignoredProperties() -> [String] {
        return ["builtBy"]
    }

    enum Event {
    }

}
