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

struct Setting: ModelType, Identifiable {
    
    enum Category: Int, Codable {
        case logout
        case night
        case theme
        
        var title: String {
            switch self {
            case .logout:
                return R.string.localizable.settingAccountLogout()
            case .night:
                return R.string.localizable.settingPreferencesNight()
            case .theme:
                return R.string.localizable.settingPreferencesTheme()
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .logout:
                return R.image.setting_cell_logout()?.template
            case .night:
                return R.image.setting_cell_night()?.template
            case .theme:
                return R.image.setting_cell_theme()?.template
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case logout     = "logout"
            case night      = "night"
            case theme      = "theme"
        }
    }
    
    var id: Category?
    var showIndicator = true
    var showSwitcher = false
    var switched = false
    var title: String?
    var detail: NSAttributedString?
    var icon: ImageSource?
    
    init() {
        
    }
    
    init(id: Category, showSwitcher: Bool = false, switched: Bool = false) {
        self.id = id
        self.showSwitcher = showSwitcher
        self.switched = switched
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
