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
import RxSwift
import RxCocoa
import RealmSwift
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
//        if let config = Misc.current() {
//            print("")
//        }
//        let a1 = Condition.Language.self.init()
//        let a2 = String(describing: Subject)
//        let aaa = UIApplication.shared.baseApiUrl
//        let bbb = UIApplication.shared.baseWebUrl
//        let abc = User.ListType.watchers.rawValue
//        let text = "做好描述(Description)：曩昔搜索引擎更正视于关键字，而如今对Description 的正视度渐渐进步。好的标签和描述可以大大进步网站排名，增长用户点击率。做好描述(Description)：曩昔搜索引擎更正视于关键字，而如今对Description 的正视度渐渐进步。好的标签和描述可以大大进步网站排名，增长用户点击率。"
//        let label = Label()
//        label.numberOfLines = 0
//        label.font = .normal(20)
//        label.text = text
//        let size = label.sizeThatFits(CGSize(width: screenWidth, height: CGFloat.greatestFiniteMagnitude))

//        let filter = Filter()
//        filter.language = Language(value: ["name": "All languages"])
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(filter)
//        }
//        // Observable.from([filter]).subscribe(Realm.rx.add())
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.dependency.applicationDidBecomeActive(application)
    }

    // MARK: - url handle
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return self.dependency.application(app, open: url, options: options)
    }

}
