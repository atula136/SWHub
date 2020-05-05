//
//  TrendingAPI.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
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

enum TrendingAPI {
    case languages
    case repositories(language: String?, since: String?)
    case developers(language: String?, since: String?)
}

extension TrendingAPI: TargetType {
    
    var baseURL: URL {
        return Constant.Network.trendingApiUrl.url!
    }
    
    var path: String {
        switch self {
            case .languages: return "/languages"
            case .repositories: return "/repositories"
            case .developers: return "/developers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case .repositories(let language, let since), .developers(let language, let since):
            parameters["language"] = language
            parameters["since"] = since
//            if let language = language {
//                parameters["language"] = language
//            }
//            if let since = since {
//                parameters["since"] = since
//            }
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