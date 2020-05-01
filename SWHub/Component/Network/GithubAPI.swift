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
//        case .wechatInfo:
//            return "/jxh5/wx_info"
//        case .homePages:
//            return "/jxh5/tags"
//        case .homeModule:
//            return "/jxh5/banners/v4"
//        case .dailyBest:
//            return "/j/api/community/items"
//        case .helpInfo:
//            return "/j/api/help/categories"
//        case .helpQuestions(let categoryID):
//            return "/j/api/help/category/" + categoryID + "/questions"
//        case .messageCenter:
//            return "/cn/api/message/my"
//        case .messageList:
//            return "/cn/api/message/list"
//        case .productList:
//            return "/api/deals/sec"
        }
    }
    
    var method: Moya.Method {
        switch self {
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
        let parameters: [String: Any] = [:]
//        parameters["platform"] = Constant.Information.platform
//        parameters["version"] = UIApplication.shared.version!
//        var userType: UserType = .normal
//        if let user = User.current(), user.info.userType != .unlogin {
//            userType = user.info.userType
//        }
//        parameters["user_type"] = userType.rawValue
//        switch self {
//        case let .homeModule(pageID):
//            parameters["url_name"] = pageID
//        case .dailyBest:
//            parameters["page_source"] = "home"
//        case .helpInfo:
//            parameters["role"] = userType.rawValue
//        case let .helpQuestions(categoryID):
//            parameters["categoryID"] = categoryID
//        case let .messageList(type, index, size):
//            parameters["message_type"] = type.rawValue
//            parameters["page"] = index
//            parameters["per_page"] = size
//        case let .productList(categoryId, sortType, pageIndex, pageSize, pageSource):
//            parameters["url_name"] = categoryId
//            parameters["sort_type"] = sortType
//            parameters["page"] = pageIndex
//            parameters["per_page"] = pageSize
//            parameters["page_source"] = pageSource
//            parameters["pid"] = stringDefault(User.current()?.info.pid, Constant.Platform.Alibc.officialPid)
//        default:
//            break
//        }
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
