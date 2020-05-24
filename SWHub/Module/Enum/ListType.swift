//
//  ListType.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/17.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

enum ListType: Int {
    case repositories
    case followers
    case following
    case watchers
    case stargazers
    case forks

    var title: String {
        switch self {
        case .repositories: return "repositories"
        case .followers: return "followers"
        case .following: return "following"
        case .watchers: return "watchers"
        case .stargazers: return "stargazers"
        case .forks: return "forks"
        }
    }

    var url: URL? {
        switch self {
        case .repositories: return Router.Repo.list.urlString.url
        case .followers: return Router.User.list.urlString.url
        case .following: return Router.Repo.list.urlString.url
        case .watchers: return Router.Repo.list.urlString.url
        case .stargazers: return Router.Repo.list.urlString.url
        case .forks: return Router.Repo.list.urlString.url
        }
    }
    
}
