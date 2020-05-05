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
    case profile
    case repository(fullname: String)
    case readme(fullname: String, ref: String?)
    case unstarRepository(fullname: String)
//    case wechatInfo
//    case homePages
//    case homeModule(pageID: String)
//    case dailyBest
//    case helpInfo
//    case helpQuestions(categoryID: String)
//    case messageCenter
//    case messageList(type: Message.TType, index: Int, size: Int)
//    case productList(categoryId: String, sortType: Int, pageIndex: Int, pageSize: Int, pageSource: String)
}

extension GithubAPI: TargetType {
    
    var baseURL: URL {
        return Constant.Network.baseApiUrl.url!
    }
    
    var path: String {
        switch self {
        case .profile: return "/user"
        case let .repository(fullname): return "/repos/\(fullname)"
        case let .readme(fullname): return "/repos/\(fullname)/readme"
        case let .unstarRepository(fullname): return "/user/starred/\(fullname)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .unstarRepository:
            return .delete
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        if let token = User.token {
            return ["Authorization": "Basic \(token)"]
        }
        return nil
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case let .readme(_, ref):
            parameters["ref"] = ref
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
        
//        switch self {
//        case .messageList(let type, let index, _):
//            path = path + "\(type.rawValue)\(index)"
//        case .productList(_, _, let pageIndex, _, _):
//            path = path + "\(pageIndex)"
//        default:
//            break
//        }
        
//        if path == "cn-api-message-list11" {
//            path = "error-401"
//        }
        
        if let url = Bundle.main.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
}
