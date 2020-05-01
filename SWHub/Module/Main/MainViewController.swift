//
//  MainViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import SwifterSwift
import URLNavigator
import SWFrame

class MainViewController: TabBarViewController, ReactorKit.View {
    
    // MARK: - Init
    init(_ navigator: NavigatorType, _ reactor: MainViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Method
    func bind(reactor: MainViewReactor) {
        super.bind(reactor: reactor)
        
        reactor.state.map { $0.keys }.subscribe(onNext: { [weak self] keys in
            guard let `self` = self else { return }
            self.innerTabBarController.viewControllers = keys.map {
                NavigationController(rootViewController: self.viewController(with: $0))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func viewController(with key: MainKey) -> BaseViewController {
        var viewController: BaseViewController?
        switch key {
        case .message:
            viewController = MessageViewController(self.navigator, MessageViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = R.image.main_tabbar_message()?.qmui_image(withTintColor: .text)?.original
            viewController?.tabBarItem.selectedImage = R.image.main_tabbar_message()?.qmui_image(withTintColor: .secondary)?.original
        case .search:
            viewController = SearchViewController(self.navigator, SearchViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = R.image.main_tabbar_search()?.qmui_image(withTintColor: .text)?.original
            viewController?.tabBarItem.selectedImage = R.image.main_tabbar_search()?.qmui_image(withTintColor: .secondary)?.original
        case .activity:
            viewController = ActivityViewController(self.navigator, ActivityViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = R.image.main_tabbar_activity()?.qmui_image(withTintColor: .text)?.original
            viewController?.tabBarItem.selectedImage = R.image.main_tabbar_activity()?.qmui_image(withTintColor: .secondary)?.original
        case .setting:
            viewController = SettingViewController(self.navigator, SettingViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = R.image.main_tabbar_settings()?.qmui_image(withTintColor: .text)?.original
            viewController?.tabBarItem.selectedImage = R.image.main_tabbar_settings()?.qmui_image(withTintColor: .secondary)?.original
        }
        viewController?.hidesBottomBarWhenPushed = false
        if let item = viewController?.tabBarItem {
            themeService.rx
                .bind({ [NSAttributedString.Key.foregroundColor: $0.textColor] }, to: item.rx.titleTextAttributes(for: .normal))
                .bind({ [NSAttributedString.Key.foregroundColor: $0.foregroundColor] }, to: item.rx.titleTextAttributes(for: .selected))
                .disposed(by: self.disposeBag)
        }
        return viewController!
    }
    
}

