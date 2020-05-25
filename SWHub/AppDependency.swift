//
//  AppDependency.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import ObjectMapper
import URLNavigator
import Iconic
import ESTabBarController_swift
import SWFrame

final class AppDependency: NSObject, AppDependencyType {

    var window: UIWindow!
    let navigator: NavigatorType
    let provider: ProviderType
    let disposeBag = DisposeBag()

    static var shared = AppDependency()

    override init() {
        self.navigator = Navigator()
        self.provider = Provider()
    }

    func initialScreen(with window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        self.window = window

        let reactor = TabBarReactor(self.provider, nil)
        let viewController = TabBarController(self.navigator, reactor)
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()

//        let home = HomeViewController(self.navigator, HomeViewReactor(self.provider, nil))
//        home.tabBarItem = ESTabBarItem(title: R.string.localizable.trending(), image: FontAwesomeIcon.homeIcon.image(ofSize: CGSize(28), color: .title).original, selectedImage: FontAwesomeIcon.homeIcon.image(ofSize: CGSize(28), color: .tint).original)
//        let setting = SettingViewController(self.navigator, SettingViewReactor(self.provider, nil))
//        setting.tabBarItem = ESTabBarItem(title: R.string.localizable.setting(), image: FontAwesomeIcon.cogIcon.image(ofSize: CGSize(28), color: .title).original, selectedImage: FontAwesomeIcon.cogIcon.image(ofSize: CGSize(28), color: .tint).original)
//        let tabBarController = ESTabBarController()
//        tabBarController.viewControllers = [home, setting]
//        self.window.rootViewController = tabBarController
//        self.window.makeKeyAndVisible()

//        let home = HomeViewController(self.navigator, HomeViewReactor(self.provider, nil))
//        home.tabBarItem.image = FontAwesomeIcon.homeIcon.image(ofSize: CGSize(28), color: .title).original
//        home.tabBarItem.selectedImage = FontAwesomeIcon.homeIcon.image(ofSize: CGSize(28), color: .tint).original
//        let setting = SettingViewController(self.navigator, SettingViewReactor(self.provider, nil))
//        setting.tabBarItem.image = FontAwesomeIcon.cogIcon.image(ofSize: CGSize(28), color: .title).original
//        setting.tabBarItem.selectedImage = FontAwesomeIcon.cogIcon.image(ofSize: CGSize(28), color: .tint).original
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [NavigationController(rootViewController: home), NavigationController(rootViewController: setting)]
//        self.window.rootViewController = tabBarController
//        self.window.makeKeyAndVisible()

        themeService.rx
            .bind({ $0.statusBarStyle }, to: UIApplication.shared.rx.statusBarStyle)
            .disposed(by: self.rx.disposeBag)
    }

    func application(_ application: UIApplication, entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        let realm = Realm.default
//        realm.beginWrite()
//        if let json = FileManager.default.json(withFilename: "languages.json"),
//            let codes = Mapper<Code>().mapArray(JSONObject: json) {
//            realm.add(codes)
//        }
//        let config = Config()
//        config.active = true
//        realm.add(config)
//        try! realm.commitWrite()
        Runtime.work()
        Library.setup()
        Appearance.config()
        Router.initialize(self.provider, self.navigator)
    }

    func application(_ application: UIApplication, leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("本地路径: \(NSHomeDirectory())")
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
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
//        let mainViewReactor = TabBarViewReactor(params: nil)
//        let mainViewController = TabBarViewController(reactor: mainViewReactor)
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
