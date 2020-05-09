//
//  Constant.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

struct Information {
////        static let clientType = ClientType.app.rawValue
////        static let comeFrom = ComeFrom.unknown.rawValue
//        static let channel = "88mq6l"
//        static let platform = "iPhone"
//        static let source = "tiaotiaoapp"
    static let swhub = "tospery/SWHub"
}

struct Constant {

    // MARK: 网络
    struct Network {
        static let timeout = 10.0
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = false
        static let trendingApiUrl = "https://github-trending-api.now.sh"
        static let gitHistoryUrl = "https://github.githistory.xyz"
        static let starHistoryUrl = "https://star-history.t9t.io"
        static let codetabsUrl = "https://api.codetabs.com/v1"
        static let profileSummaryUrl = "https://profile-summary-for-github.com"
    }

    // MARK: 度量
    struct Metric {
        static let margin: CGFloat = 10
        static let padding: CGFloat = 4
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 40
        static let segmentedControlHeight: CGFloat = 36
    }

    struct Font {
    }

    struct Storage {
        static let themeKey = "ThemeKey"
        static let isDarkKey = "isDarkKey"
    }

    struct Platform {
        struct Github {
            static let appId = "00cbdbffb01ec72e280a"
            static let apiKey = "5a39979251c0452a9476bd45c82a14d8e98c3fb3"
        }

        struct Alibc {
            static let appSecret = "afd609c357f5f51901ff5b3f98d24f44"
            static let officialPid = "mm_126226387_36534090_130840713"
        }
    }

    struct Animation {
        static let transform = "transform"
    }

    // MARK: 钥匙串
    struct Keychain {
    }
}
