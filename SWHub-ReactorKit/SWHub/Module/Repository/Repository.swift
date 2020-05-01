//
//  Repository.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import KeychainAccess
import SWFrame

struct Repository: ModelType, Storable, Subjective {
    
    var fork: Bool?
    var privated: Bool?
    var id: Int?
    var stargazersCount: Int?
    var name: String?
    var fullName: String?
    var nodeId: String?
    var language: String?
    var languageColor: String?
    var description: String?
    var keysUrl: String?
    var collaboratorsUrl: String?
    var issueEventsUrl: String?
    var assigneesUrl: String?
    var branchesUrl: String?
    var blobsUrl: String?
    var gitTagsUrl: String?
    var gitRefsUrl: String?
    var treesUrl: String?
    var statusesUrl: String?
    var commitsUrl: String?
    var gitCommitsUrl: String?
    var commentsUrl: String?
    var issueCommentUrl: String?
    var contentsUrl: String?
    var compareUrl: String?
    var archiveUrl: String?
    var issuesUrl: String?
    var pullsUrl: String?
    var milestonesUrl: String?
    var notificationsUrl: String?
    var labelsUrl: String?
    var releasesUrl: String?
    var url: URL?
    var htmlUrl: URL?
    var forksUrl: URL?
    var teamsUrl: URL?
    var hooksUrl: URL?
    var eventsUrl: URL?
    var tagsUrl: URL?
    var languagesUrl: URL?
    var stargazersUrl: URL?
    var contributorsUrl: URL?
    var subscribersUrl: URL?
    var subscriptionUrl: URL?
    var mergesUrl: URL?
    var downloadsUrl: URL?
    var deploymentsUrl: URL?
    var owner: User?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        fork                    <- map["fork"]
        privated                <- map["private"]
        id                      <- map["id"]
        stargazersCount         <- map["stargazers_count"]
        name                    <- map["name"]
        fullName                <- map["full_name"]
        nodeId                  <- map["node_id"]
        language                <- map["language"]
        languageColor           <- map["languageColor"]
        description             <- map["description"]
        keysUrl                 <- map["keys_url"]
        collaboratorsUrl        <- map["collaborators_url"]
        issueEventsUrl          <- map["issue_events_url"]
        assigneesUrl            <- map["assignees_url"]
        branchesUrl             <- map["branches_url"]
        blobsUrl                <- map["blobs_url"]
        gitTagsUrl              <- map["git_tags_url"]
        gitRefsUrl              <- map["git_refs_url"]
        treesUrl                <- map["trees_url"]
        statusesUrl             <- map["statuses_url"]
        commitsUrl              <- map["commits_url"]
        gitCommitsUrl           <- map["git_commits_url"]
        commentsUrl             <- map["comments_url"]
        issueCommentUrl         <- map["issue_comment_url"]
        contentsUrl             <- map["contents_url"]
        compareUrl              <- map["compare_url"]
        archiveUrl              <- map["archive_url"]
        issuesUrl               <- map["issues_url"]
        pullsUrl                <- map["pulls_url"]
        milestonesUrl           <- map["milestones_url"]
        notificationsUrl        <- map["notifications_url"]
        labelsUrl               <- map["labels_url"]
        releasesUrl             <- map["releases_url"]
        url                     <- (map["url"], URLTransform())
        htmlUrl                 <- (map["html_url"], URLTransform())
        forksUrl                <- (map["forks_url"], URLTransform())
        teamsUrl                <- (map["teams_url"], URLTransform())
        hooksUrl                <- (map["hooks_url"], URLTransform())
        eventsUrl               <- (map["events_url"], URLTransform())
        tagsUrl                 <- (map["tags_url"], URLTransform())
        languagesUrl            <- (map["languages_url"], URLTransform())
        stargazersUrl           <- (map["stargazers_url"], URLTransform())
        contributorsUrl         <- (map["contributors_url"], URLTransform())
        subscribersUrl          <- (map["subscribers_url"], URLTransform())
        subscriptionUrl         <- (map["subscription_url"], URLTransform())
        mergesUrl               <- (map["merges_url"], URLTransform())
        downloadsUrl            <- (map["downloads_url"], URLTransform())
        deploymentsUrl          <- (map["deployments_url"], URLTransform())
        owner                   <- map["owner"]
    }
    
    func detail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []
        let starsString = (self.stargazersCount ?? 0).kFormatted().styled(with: .color(.text))
        let starsImage = R.image.setting_badge_star()?.filled(withColor: .text).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        texts.append(.composed(of: [
            starsImage, Special.space, starsString, Special.space, Special.tab
        ]))
        
        if let languageString = self.language?.styled(with: .color(.text)) {
            let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(self.languageColor ?? "") ?? .clear)]))
            texts.append(.composed(of: [
                languageColorShape, Special.space, languageString
            ]))
        }
        
        return .composed(of: texts)
    }
    
}
