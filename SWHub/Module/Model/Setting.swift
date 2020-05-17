//
//  Setting.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import Iconic
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

    init(id: Key, accessory: AccessoryType = .indicator, switched: Bool = false) {
        self.id = id
        self.accessory = accessory
        self.switched = switched
        self.title = id.title
        self.icon = id.icon
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
    }

    enum Event {
        case night(Bool)
    }

    enum Key: Int, Codable {
        case profile
        case login
        case night
        case color
        case cache

        var title: String? {
            switch self {
            case .night:
                return R.string.localizable.settingPreferencesNight()
            case .color:
                return R.string.localizable.settingPreferencesTheme()
            case .cache:
                return R.string.localizable.clearCache()
            default:
                return nil
            }
        }

        var icon: UIImage? {
            switch self {
            case .night:
                return FontAwesomeIcon.lightBulbIcon.image(ofSize: .init(32), color: .tint).template
            case .color:
                return FontAwesomeIcon.eyeOpenIcon.image(ofSize: .init(32), color: .tint).template
            case .cache:
                return FontAwesomeIcon.trashIcon.image(ofSize: .init(32), color: .tint).template
            default:
                return nil
            }
        }

    }
}
