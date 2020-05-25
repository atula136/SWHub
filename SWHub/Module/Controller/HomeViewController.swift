//
//  HomeViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import Iconic
import Parchment
import SnapKit
import SwifterSwift
import SWFrame

class HomeViewController: ScrollViewController, ReactorKit.View {

    lazy var paging: NavigationBarPagingViewController = {
        let paging = NavigationBarPagingViewController()
        paging.menuBackgroundColor = .clear
        paging.menuHorizontalAlignment = .center
        paging.borderOptions = .hidden
        paging.menuItemSize = .selfSizing(estimatedWidth: 100, height: navigationBarHeight)
        return paging
    }()

    init(_ navigator: NavigatorType, _ reactor: HomeViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.currentState.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(self.paging)
        self.view.addSubview(self.paging.view)
        let tabBarHeight = self.tabBarController?.tabBar.height ?? 0
        self.paging.view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(self.contentTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        self.paging.didMove(toParent: self)
        self.paging.dataSource = self

        self.navigationBar.addButtonToRight(FontAwesomeIcon.reorderIcon.image(ofSize: .init(width: 20, height: 20), color: .tint)).rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.navigator.present(Router.condition.urlString, wrap: NavigationController.self)
        }).disposed(by: self.disposeBag)

        self.paging.collectionView.size = CGSize(width: self.view.width, height: navigationBarHeight)
        self.navigationBar.titleView = self.paging.collectionView

        themeService.rx
            .bind({ $0.special1Color }, to: self.paging.view.rx.backgroundColor)
            .bind({ $0.tintColor }, to: [self.paging.rx.indicatorColor, self.paging.rx.selectedTextColor])
            .bind({ $0.titleColor }, to: self.paging.rx.textColor)
            .disposed(by: self.rx.disposeBag)
        themeService.typeStream.delay(.milliseconds(10), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.paging.reloadMenu()
        }).disposed(by: self.rx.disposeBag)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        (self.tabBarController as? TabBarController)?.safeBottomView.isHidden = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        (self.tabBarController as? TabBarController)?.safeBottomView.isHidden = true
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func bind(reactor: HomeViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.items }
            .mapToVoid()
            .bind(to: self.paging.rx.reloadData)
            .disposed(by: self.disposeBag)
    }

}

extension HomeViewController: PagingViewControllerDataSource {

    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return self.reactor!.currentState.items.count
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: self.reactor!.currentState.items[index].title)
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        switch self.reactor!.currentState.items[index] {
        case .repo:
            return TrendingRepoListViewController(self.navigator, TrendingRepoListViewReactor(self.reactor!.provider, nil))
        case .user:
            return TrendingUserListViewController(self.navigator, TrendingUserListViewReactor(self.reactor!.provider, nil))
        }
    }

}

class NavigationBarPagingView: PagingView {

    override func setupConstraints() {
        pageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

class NavigationBarPagingViewController: PagingViewController {

    override func loadView() {
        view = NavigationBarPagingView(options: options, collectionView: collectionView, pageView: pageViewController.view)
    }

}
