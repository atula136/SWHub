//
//  AppDelegate.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SwifterSwift
import KeychainAccess
import ObjectMapper
import SWFrame

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dependency = AppDependency.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.dependency.application(application, entryDidFinishLaunchingWithOptions: launchOptions)
        self.dependency.initialScreen(with: &self.window)
        self.dependency.application(application, leaveDidFinishLaunchingWithOptions: launchOptions)
        
        perform(#selector(test(launchOptions:)), with: launchOptions, afterDelay: 3.0)
        
        return true
    }

    @objc func test(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        if let misc = Misc.current() {
//            print("")
//        }
//        let a1 = Condition.Language.self.init()
//        let a2 = String(describing: Subject)
//        let aaa = UIApplication.shared.baseApiUrl
//        let bbb = UIApplication.shared.baseWebUrl
//        print("")
    }
    
    // MARK: - url handle
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return self.dependency.application(app, open: url, options: options)
    }

}

