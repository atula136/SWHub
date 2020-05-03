//
//  HomeViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import URLNavigator
import Rswift
import Parchment
import SnapKit
import SwifterSwift
import SWFrame

class HomeViewController: ScrollViewController, ReactorKit.View {
    
    lazy var paging: NavigationBarPagingViewController = {
        let paging = NavigationBarPagingViewController()
        paging.menuBackgroundColor = .clear
        paging.menuHorizontalAlignment = .center
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
        self.paging.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.paging.didMove(toParent: self)
        self.paging.dataSource = self
        
        self.navigationBar.titleView = self.paging.collectionView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func bind(reactor: HomeViewReactor) {
        super.bind(reactor: reactor)
        // state
        reactor.state.map{ $0.items }
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
        case .repository:
            return RepositoryListViewController(self.navigator, RepositoryListViewReactor(self.reactor!.provider, nil))
        case .developer:
            return DeveloperListViewController(self.navigator, DeveloperListViewReactor(self.reactor!.provider, nil))
        }
    }

}

class NavigationBarPagingView: PagingView {
  
    override func setupConstraints() {
        pageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
}

class NavigationBarPagingViewController: PagingViewController {
    
    override func loadView() {
        view = NavigationBarPagingView(options: options, collectionView: collectionView, pageView: pageViewController.view)
    }
    
}
