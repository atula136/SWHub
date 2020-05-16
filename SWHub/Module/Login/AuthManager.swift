//
//  AuthManager.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/27.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import KeychainAccess
import SWFrame

//enum TokenType {
//    case basic(token: String)
//    case unauthorized
//
//    var description: String {
//        switch self {
//        case .basic: return "basic"
//        case .unauthorized: return "unauthorized"
//        }
//    }
//}
//
//struct Token: ModelType {
//
//    var isValid = false
//    var value: String?
//
//    init() {
//    }
//
//    init(_ value: String) {
//        self.value = value
//    }
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        isValid <- map["valid"]
//        value <- map["value"]
//    }
//
//    func type() -> TokenType {
//        if let token = value {
//            return .basic(token: token)
//        }
//        return .unauthorized
//    }
//}
//
//class AuthManager {
//
//    static let shared = AuthManager()
//
//    fileprivate let tokenKey = "tokenKey"
//    fileprivate let keychain = Keychain()
//
//    init() {
//    }
//
//    var token: Token? {
//        get {
//            guard let jsonString = keychain[tokenKey] else { return nil }
//            return Mapper<Token>().map(JSONString: jsonString)
//        }
//        set {
//            if let token = newValue, let jsonString = token.toJSONString() {
//                keychain[tokenKey] = jsonString
//            } else {
//                keychain[tokenKey] = nil
//            }
//        }
//    }
//
//    var hasValidToken: Bool {
//        return token?.isValid == true
//    }
//
//}
