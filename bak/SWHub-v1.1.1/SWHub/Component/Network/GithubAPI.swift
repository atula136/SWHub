//
//  GithubAPI.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/27.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Alamofire
import Rswift
import SWFrame

enum GithubAPI {
    case login(account: String, password: String)
    case user(username: String)
    case repo(fullname: String)
    case readme(fullname: String, ref: String?)
    case checkStarring(fullname: String)
    case starRepo(fullname: String)
    case unstarRepo(fullname: String)
    case watchers(fullname: String, page: Int)
    case stargazers(fullname: String, page: Int)
    case forks(fullname: String, page: Int)
    case userRepos(username: String, page: Int)
    case userFollowers(username: String, page: Int)
}

extension GithubAPI: TargetType {

    var baseURL: URL {
        return UIApplication.shared.baseApiUrl.url!
    }

    var path: String {
        switch self {
        case .login: return "/user"
        case let .user(username): return "/users/\(username)"
        case let .repo(fullname): return "/repos/\(fullname)"
        case let .readme(fullname, _): return "/repos/\(fullname)/readme"
        case .checkStarring(let fullname),
             .starRepo(let fullname),
             .unstarRepo(let fullname):
            return "/user/starred/\(fullname)"
        case let .watchers(fullname, _): return "/repos/\(fullname)/subscribers"
        case let .stargazers(fullname, _): return "/repos/\(fullname)/stargazers"
        case let .forks(fullname, _): return "/repos/\(fullname)/forks"
        case let .userRepos(username, _): return "/users/\(username)/repos"
        case let .userFollowers(username, _): return "/users/\(username)/followers"
        }
    }

    var method: Moya.Method {
        switch self {
        case .starRepo:
            return .put
        case .unstarRepo:
            return .delete
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case let .login(account, password):
            if let token = "\(account):\(password)".base64Encoded {
                return ["Authorization": "Basic \(token)"]
            }
        default:
            if let token = User.token {
                return ["Authorization": "Basic \(token)"]
            }
        }
        return nil
    }

    var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case let .readme(_, ref):
            parameters["ref"] = ref
        case .watchers(_, let page), .stargazers(_, let page), .forks(_, let page),
             .userRepos(_, let page), .userFollowers(_, let page):
            parameters["page"] = page
        default:
            break
        }
        if parameters.isEmpty {
            return .requestPlain
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var validationType: ValidationType {
        return .none
    }

    var sampleData: Data {
        var path = self.path.replacingOccurrences(of: "/", with: "-")
        let index = path.index(after: path.startIndex)
        path = String(path[index...])
        if let url = Bundle.main.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
}
