//
//  ResponseType.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/27.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

protocol ResponseType {
    var code: Int { get }
    var message: String { get }
}

func mappingCode(map: Map) -> Int {
    var code: Int = 0
    code        <- map["code"]
    if code == 0 {
        code    <- map["statusCode"]
    }
    if code == 0 {
        code    <- map["status"]
        if code == 1 {   // 微信信息
            code = 200
        }
    }
    return code
}

func mappingMessage(map: Map) -> String {
    var message: String = ""
    message     <- map["message"]
    if message.isEmpty {
        message <- map["displayErrorInfo"]
    }
    return message
}

struct ObjectResponse<Data: ModelType>: ResponseType, ModelType {

    var code: Int = 0
    var message: String = ""
    var data: Data?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        code = mappingCode(map: map)
        message = mappingMessage(map: map)
        data            <- map["data"]
        if data == nil {
            data        <- map["result"]
        }
    }
}

struct ArrayResponse<Data: ModelType>: ResponseType, ModelType {

    var code: Int = 0
    var message: String = ""
    var data: [Data]?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        code = mappingCode(map: map)
        message = mappingMessage(map: map)
        data            <- map["data"]
        if data == nil {
            data        <- map["result"]
        }
    }
}
