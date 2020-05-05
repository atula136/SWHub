//
//  Repository.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import ObjectMapper
import SWFrame

struct Repository: ModelType, Subjective {
    
    var `private` = false
    var fork = false
    var hasIssues = false
    var hasProjects = false
    var hasDownloads = false
    var hasWiki = false
    var hasPages = false
    var archived = false
    var disabled = false
    var id: Int?
    var size: Int?
    var stargazersCount: Int?
    var watchersCount: Int?
    var forksCount: Int?
    var openIssuesCount: Int?
    var forks: Int?
    var openIssues: Int?
    var watchers: Int?
    var networkCount: Int?
    var subscribersCount: Int?
    var nodeId: String?
    var name: String?
    var fullName: String?
    var description: String?
    var language: String?
    var defaultBranch: String?
    var tempCloneToken: String?
    var createdAt: String?
    var updatedAt: String?
    var pushedAt: String?
    var homepage: String?
    var gitUrl: String?
    var sshUrl: String?
    var cloneUrl: String?
    var svnUrl: String?
    var mirrorUrl: String?
    var htmlUrl: String?
    var url: String?
    var forksUrl: String?
    var keysUrl: String?
    var collaboratorsUrl: String?
    var teamsUrl: String?
    var hooksUrl: String?
    var issueEventsUrl: String?
    var eventsUrl: String?
    var assigneesUrl: String?
    var branchesUrl: String?
    var tagsUrl: String?
    var blobsUrl: String?
    var gitTagsUrl: String?
    var gitRefsUrl: String?
    var treesUrl: String?
    var statusesUrl: String?
    var languagesUrl: String?
    var stargazersUrl: String?
    var contributorsUrl: String?
    var subscribersUrl: String?
    var subscriptionUrl: String?
    var commitsUrl: String?
    var gitCommitsUrl: String?
    var commentsUrl: String?
    var issueCommentUrl: String?
    var contentsUrl: String?
    var compareUrl: String?
    var mergesUrl: String?
    var archiveUrl: String?
    var downloadsUrl: String?
    var issuesUrl: String?
    var pullsUrl: String?
    var milestonesUrl: String?
    var notificationsUrl: String?
    var labelsUrl: String?
    var releasesUrl: String?
    var deploymentsUrl: String?
    var license: License?
    var permissions: Permissions?
    var owner: Developer?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        `private`                   <- map["private"]
        fork                        <- map["fork"]
        hasIssues                   <- map["has_issues"]
        hasProjects                 <- map["has_projects"]
        hasDownloads                <- map["has_downloads"]
        hasWiki                     <- map["has_wiki"]
        hasPages                    <- map["has_pages"]
        archived                    <- map["archived"]
        disabled                    <- map["disabled"]
        id                          <- map["id"]
        size                        <- map["size"]
        stargazersCount             <- map["stargazers_count"]
        watchersCount               <- map["watchers_count"]
        forksCount                  <- map["forks_count"]
        openIssuesCount             <- map["open_issues_count"]
        forks                       <- map["forks"]
        openIssues                  <- map["open_issues"]
        watchers                    <- map["watchers"]
        networkCount                <- map["network_count"]
        subscribersCount            <- map["subscribers_count"]
        nodeId                      <- map["node_id"]
        name                        <- map["name"]
        fullName                    <- map["full_name"]
        description                 <- map["description"]
        language                    <- map["language"]
        defaultBranch               <- map["default_branch"]
        tempCloneToken              <- map["temp_clone_token"]
        createdAt                   <- map["created_at"]
        updatedAt                   <- map["updated_at"]
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
    }
    
    
    struct License: ModelType, Subjective {
        
        var id: Int?
        var key: String?
        var name: String?
        var spdxId: String?
        var url: String?
        var nodeId: String?
        
        init() {
            
        }
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            key                     <- map["key"]
            name                    <- map["name"]
            spdxId                  <- map["spdx_id"]
            url                     <- map["url"]
            nodeId                  <- map["node_id"]
        }
        
    }
    
    struct Permissions: ModelType, Subjective {
        
        var id: Int?
        var admin = false
        var push = false
        var pull = false
        
        init() {
            
        }
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            admin                   <- map["admin"]
            push                    <- map["push"]
            pull                    <- map["pull"]
        }
        
    }
    
}

extension Repository: Eventable {
    
    enum Event {
        
    }
    
}
