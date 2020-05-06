//
//  Setting.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ObjectMapper
import SWFrame

struct Setting: ModelType, Identifiable, Eventable {
    
    var id: Key?
    var switched = false
    var title: String?
    var detail: NSAttributedString?
    var icon: ImageSource?
    var accessory = AccessoryType.indicator
    
    init() {
        
    }
    
    init(id: Key, accessory: AccessoryType = .indicator) {
        self.id = id
        self.accessory = accessory
        self.title = id.title
        self.icon = id.icon
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    enum Event {
        case dark(Bool)
    }
    
    enum Key: Int, Codable {
        case profile
        case project
        case logout
        case dark
        case color
        
        var title: String? {
            switch self {
            case .logout:
                return R.string.localizable.settingAccountLogout()
            case .dark:
                return R.string.localizable.settingPreferencesNight()
            case .color:
                return R.string.localizable.settingPreferencesTheme()
            default:
                return nil
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .logout:
                return R.image.setting_cell_logout()?.template
            case .dark:
                return R.image.setting_cell_night()?.template
            case .color:
                return R.image.setting_cell_theme()?.template
            default:
                return nil
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case profile        = "profile"
            case logout         = "logout"
            case project        = "project"
            case dark           = "dark"
            case color          = "color"
        }
    }
    
}
