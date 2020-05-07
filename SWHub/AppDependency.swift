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
import URLNavigator
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
        User.subject().distinctUntilChanged().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] user in
            guard let `self` = self else { return }
            if user != nil {
                let mainViewReactor = MainViewReactor(self.provider, nil)
                let mainViewController = MainViewController(self.navigator, mainViewReactor)
                self.window.rootViewController = mainViewController
                self.window.makeKeyAndVisible()
            } else {
                let loginViewReactor = LoginViewReactor(self.provider, nil)
                let loginViewController = LoginViewController(self.navigator, loginViewReactor)
                self.window.rootViewController = NavigationController(rootViewController: loginViewController)
                self.window.makeKeyAndVisible()
            }
        }).disposed(by: self.disposeBag)

        themeService.rx
            .bind({ $0.statusBarStyle }, to: UIApplication.shared.rx.statusBarStyle)
            .disposed(by: self.rx.disposeBag)
    }

    func application(_ application: UIApplication, entryDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Runtime.work()
        Library.setup()
        Appearance.config()
        Router.initialize(self.provider, self.navigator)
    }

    func application(_ application: UIApplication, leaveDidFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
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
