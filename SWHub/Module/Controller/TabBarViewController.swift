//
//  TabBarViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import URLNavigator
import ESTabBarController_swift
import Iconic
import NSObject_Rx
import SWFrame

class TabBarViewController: SWFrame.TabBarViewController, ReactorKit.View {

    // MARK: - Init
    init(_ navigator: NavigatorType, _ reactor: TabBarViewReactor) {
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
        self.tab.viewControllers = self.reactor?.currentState.keys.map { NavigationController(rootViewController: self.viewController(with: $0)) }
        themeService.rx
            .bind({ $0.dimColor }, to: self.tab.tabBar.rx.barTintColor/*[self.tab.tabBar.rx.barTintColor, self.safeBottomView.rx.backgroundColor]*/)
            .bind({ $0.tintColor }, to: self.tab.tabBar.rx.tintColor)
            .disposed(by: self.rx.disposeBag)
        if #available(iOS 10.0, *) {
            themeService.rx
                .bind({ $0.titleColor }, to: self.tab.tabBar.rx.unselectedItemTintColor)
                .disposed(by: self.rx.disposeBag)
        }
        themeService.typeStream.delay(.milliseconds(10), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] theme in
            guard let `self` = self else { return }
            if let items = self.tab.tabBar.items {
                let color = theme.associatedObject.titleColor
                let selectedColor = theme.associatedObject.tintColor
                for item in items {
                    item.image = item.image?.qmui_image(withTintColor: color)?.original
                    item.selectedImage = item.selectedImage?.qmui_image(withTintColor: selectedColor)?.original
                }
            }
        }).disposed(by: self.rx.disposeBag)

        self.view.backgroundColor = .red  // TODO
    }

    // MARK: - Method
    func bind(reactor: TabBarViewReactor) {
        super.bind(reactor: reactor)
//        reactor.state.map { $0.keys }.subscribe(onNext: { [weak self] keys in
//            guard let `self` = self else { return }
//            self.tab.viewControllers = keys.map {
//                NavigationController(rootViewController: self.viewController(with: $0))
//            }
//        }).disposed(by: self.disposeBag)
    }

    func viewController(with key: MainKey) -> BaseViewController {
        let s28 = CGSize(width: 28, height: 28)
        var viewController: BaseViewController?
        switch key {
        case .home:
            viewController = HomeViewController(self.navigator, HomeViewReactor(self.reactor!.provider, nil))
//            viewController?.tabBarItem.image = FontAwesomeIcon.homeIcon.image(ofSize: s28, color: .title).original
//            viewController?.tabBarItem.selectedImage = FontAwesomeIcon.homeIcon.image(ofSize: s28, color: .tint).original
            viewController?.tabBarItem = ESTabBarItem(title: R.string.localizable.trending(), image: FontAwesomeIcon.homeIcon.image(ofSize: s28, color: .title).original, selectedImage: FontAwesomeIcon.homeIcon.image(ofSize: s28, color: .tint).original)
        case .message:
            viewController = MessageViewController(self.navigator, MessageViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = FontAwesomeIcon.commentsIcon.image(ofSize: s28, color: .title).original
            viewController?.tabBarItem.selectedImage = FontAwesomeIcon.commentsIcon.image(ofSize: s28, color: .tint).original
        case .search:
            viewController = SearchViewController(self.navigator, SearchViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = FontAwesomeIcon.searchIcon.image(ofSize: s28, color: .title).original
            viewController?.tabBarItem.selectedImage = FontAwesomeIcon.searchIcon.image(ofSize: s28, color: .tint).original
        case .activity:
            viewController = ActivityViewController(self.navigator, ActivityViewReactor(self.reactor!.provider, nil))
            viewController?.tabBarItem.image = FontAwesomeIcon.bellIcon.image(ofSize: s28, color: .title).original
            viewController?.tabBarItem.selectedImage = FontAwesomeIcon.bellIcon.image(ofSize: s28, color: .tint).original
        case .setting:
            viewController = SettingViewController(self.navigator, SettingViewReactor(self.reactor!.provider, nil))
//            viewController?.tabBarItem.image = FontAwesomeIcon.cogIcon.image(ofSize: s28, color: .title).original
//            viewController?.tabBarItem.selectedImage = FontAwesomeIcon.cogIcon.image(ofSize: s28, color: .tint).original
            viewController?.tabBarItem = ESTabBarItem(title: R.string.localizable.setting(), image: FontAwesomeIcon.cogIcon.image(ofSize: s28, color: .title).original, selectedImage: FontAwesomeIcon.cogIcon.image(ofSize: s28, color: .tint).original)
        }
        viewController?.hidesBottomBarWhenPushed = false
        if let item = viewController?.tabBarItem {
            if #available(iOS 10.0, *) {
            } else {
                themeService.rx
                    .bind({ [NSAttributedString.Key.foregroundColor: $0.titleColor] }, to: item.rx.titleTextAttributes(for: .normal))
                    .bind({ [NSAttributedString.Key.foregroundColor: $0.tintColor] }, to: item.rx.titleTextAttributes(for: .selected))
                    .disposed(by: self.rx.disposeBag)
            }
        }
        return viewController!
    }
}
