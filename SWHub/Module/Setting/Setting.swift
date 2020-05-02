//
//  Setting.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Setting: ModelType, Identifiable, Eventable {
    
    enum Event {
        case night(Bool)
    }
    
    enum Category: Int, Codable {
        case logout
        case night
        case color
        
        var title: String {
            switch self {
            case .logout:
                return R.string.localizable.settingAccountLogout()
            case .night:
                return R.string.localizable.settingPreferencesNight()
            case .color:
                return R.string.localizable.settingPreferencesTheme()
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .logout:
                return R.image.setting_cell_logout()?.template
            case .night:
                return R.image.setting_cell_night()?.template
            case .color:
                return R.image.setting_cell_theme()?.template
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case logout     = "logout"
            case night      = "night"
            case color      = "color"
        }
    }
    
    var id: Category?
    var accessory = NormalItem.AccessoryType.indicator
    var title: String?
    var detail: NSAttributedString?
    var icon: ImageSource?
    
    init() {
        
    }
    
    init(id: Category, accessory: NormalItem.AccessoryType = .indicator) {
        self.id = id
        self.accessory = accessory
        self.title = id.title
        self.icon = id.icon
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        title       <- map["title"]
    }
    
}
