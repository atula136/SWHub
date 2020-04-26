//
//  AppDependency.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import URLNavigator
import SWFrame

final class AppDependency: AppDependencyType {
    
    var window: UIWindow!
    let navigator: NavigatorType
    let provider: ProviderType
    
    static var shared = AppDependency()
    
    init() {
        self.navigator = Navigator()
        self.provider = Provider()
    }
    
    func initialScreen(with window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        self.window = window
//
//        let mainViewReactor = MainViewReactor(self.provider, nil)
//        let mainViewController = MainViewController(self.navigator, mainViewReactor)
//        self.window.rootViewController = mainViewController
//        self.window.makeKeyAndVisible()
        
        let loginViewReactor = LoginViewReactor(self.provider, nil)
        let loginViewController = LoginViewController(self.navigator, loginViewReactor)
        self.window.rootViewController = NavigationController(rootViewController: loginViewController)
        self.window.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        Runtime.work()
        Library.setup()
        Appearance.config()
        Router.initialize(self.provider, self.navigator)
    }
    
    func application(_ application: UIApplication, leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        var optionParam: [String: Any] = [:]
//        for (kind, value) in options {
//            optionParam[kind.rawValue] = value
//        }
//        if AlibcTradeSDK.sharedInstance()?.application(app, open: url, options: optionParam) ?? false {
//            return true
//        }
        return true
    }
    
//    static var shared = AppDependency()
//
//    required init() {
//        super.init()
//    }
//
//    override func initialScreen(with window: inout UIWindow?) {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.backgroundColor = .white
//        self.window = window
//
//        let mainViewReactor = MainViewReactor(params: nil)
//        let mainViewController = MainViewController(reactor: mainViewReactor)
//        self.window.rootViewController = mainViewController
//        self.window.makeKeyAndVisible()
//    }
//
//    override func application(_ application: UIApplication, entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
//        Runtime.work()
//        Library.setup()
//        Appearance.config()
//        Router.initialize(navigator: self.navigator)
//    }
//
//    override func application(_ application: UIApplication, leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
//
//    }
    
}
