//
//  Router.swift
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

enum Router {
    case alert
    case sheet
    case popup
    case toast
    case login
    case setting
    case color
    case help
    case category
    case condition
    
    enum Repository {
        case list
        case detail

        var pattern: String {
            var path: String?
            switch self {
            case .list:
                path = "repository/list"
            case .detail:
                path = "repository/detail"
            }
            return UIApplication.shared.scheme + "://" + path!
        }
    }
    
    var pattern: String {
        var path: String?
        switch self {
        case .alert:
            path = "alert"
        case .sheet:
            path = "sheet"
        case .popup:
            path = "popup"
        case .toast:
            path = "toast"
        case .login:
            path = "login"
        case .setting:
            path = "setting"
        case .color:
            path = "color"
        case .help:
            path = "help"
        case .category:
            path = "tag_page/<string:categoryId>"
        case .condition:
            path = "condition"
        }
        return UIApplication.shared.scheme + "://" + path!
    }
    
    static func initialize(_ provider: ProviderType, _ navigator: NavigatorType) {
        let parameters = { (url: URLConvertible, values: [String: Any], context: Any?) -> Dictionary<String, Any>? in
            var parameters: Dictionary<String, Any> = url.queryParameters
            for (key, value) in values {
                parameters[key] = value
            }
            if let context = context {
                parameters[Parameter.routeContext] = context
            }
            return parameters
        }
        
        // 1. 颜色主题
        navigator.register(self.color.pattern) { url, values, context in
            MyColorViewController(navigator, MyColorViewReactor(provider, parameters(url, values, context)))
        }
        // 2. 搜索条件
        navigator.register(self.condition.pattern) { url, values, context in
            ConditionViewController(navigator, ConditionViewReactor(provider, parameters(url, values, context)))
        }
        // 3. 仓库详情
        navigator.register(self.Repository.detail.pattern) { url, values, context in
            RepositoryViewController(navigator, RepositoryViewReactor(provider, parameters(url, values, context)))
        }
        
//        // 1. 网页
//        let webFactory: ViewControllerFactory = { (url: URLConvertible, values: [String: Any], context: Any?) in
//            guard let url = url.urlValue else { return nil }
//            // 1. 判断是否有原生实现
//            let string = url.absoluteString
//            if string.hasPrefix(Constant.Network.baseWebUrl) {
//                let url = string.replacingOccurrences(of: Constant.Network.baseWebUrl, with: UIApplication.shared.scheme + "://")
//                if let _ = navigator.push(url, context: context) {
//                    return nil
//                }
//            }
//            // 2. 网页跳转
//            var paramters = [Parameter.url: url.absoluteString]
//            if let title = url.queryValue(for: Parameter.title) {
//                paramters[Parameter.title] = title
//            }
//            return WebViewController(navigator, WebViewReactor(provider, paramters))
//        }
//        navigator.register("http://<path:_>", webFactory)
//        navigator.register("https://<path:_>", webFactory)
//
//        // 2. 模式
//        let parameters = { (url: URLConvertible, values: [String: Any], context: Any?) -> Dictionary<String, Any>? in
//            var parameters: Dictionary<String, Any> = url.queryParameters
//            for (key, value) in values {
//                parameters[key] = value
//            }
//            if let context = context {
//                parameters[routeContextKey] = context
//            }
//            return parameters
//        }
//
////        navigator.register(self.help.rawValue) { _, _, _ -> UIViewController? in
////            HelpViewController(navigator: navigator, reactor: HelpViewReactor(provider: provider, params: nil))
////        }
//
//        navigator.register(self.login.url) { _, values, _ in
//            LoginViewController(navigator, LoginViewReactor(provider, nil))
//        }
//
////        navigator.register(self.message.url) { _, values, _ in
////            MessageCenterViewController(navigator, MessageCenterViewReactor(provider, nil))
////        }
//
//        navigator.register(self.Message.center.url) { url, values, context in
//            MessageCenterViewController(navigator, MessageCenterViewReactor(provider, nil))
//        }
//
//        navigator.register(self.Message.list.url) { url, values, context in
//            MessageListViewController(navigator, MessageListViewReactor(provider, url.queryParameters))
//        }
//
//        navigator.register(self.setting.url) { _, values, _ in
//            SettingViewController(navigator, SettingViewReactor(provider, nil))
//        }
//
//        navigator.register(self.category.url) { url, values, context in
//            ProductListViewController(navigator, ProductListViewReactor(provider, parameters(url, values, context)))
//        }
//
//        // 3. 弹窗
//        navigator.handle(self.alert.url) { url, values, context -> Bool in
//            let title = url.queryParameters[Parameter.title]
//            let message = url.queryParameters[Parameter.message]
//            guard title != nil || message != nil else { return false }
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            if let context = context as? [String: Any],
//                let observer = context[routeObserverKey] as? AnyObserver<AlertActionType>,
//                let actions = context[routeContextKey] as? [AlertActionType] {
//                for action in actions {
//                    let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
//                        observer.onNext(action)
//                        observer.onCompleted()
//                    }
//                    alertController.addAction(alertAction)
//                }
//            }
//            navigator.present(alertController)
//            return true
//        }
    }
    
}
