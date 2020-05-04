//
//  Condition.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Condition {
    
    enum Since: Int, Codable {
        case daily, weekly, monthly

        static let allValues = [daily, weekly, monthly]
        
        var title: String {
            switch self {
            case .daily: return R.string.localizable.conditionSinceDaily()
            case .weekly: return R.string.localizable.conditionSinceWeekly()
            case .monthly: return R.string.localizable.conditionSinceMonthly()
            }
        }

        var paramValue: String {
            switch self {
            case .daily: return "daily"
            case .weekly: return "weekly"
            case .monthly: return "monthly"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case daily      = "daily"
            case weekly     = "weekly"
            case monthly    = "monthly"
        }
        
    }
    
    struct Language: ModelType, Subjective {
        
        var id: Int?
        var name: String?
        var urlParam: String?
        
        init() {
            
        }
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            name            <- map["name"]
            urlParam        <- map["urlParam"]
        }
        
    }
    
}
