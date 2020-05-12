//
//  TrendingRepoListViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import URLNavigator
import ReactorKit
import ReusableKit
import RxDataSources
import SWFrame

class TrendingRepoListViewController: CollectionViewController, ReactorKit.View {

    struct Reusable {
        static let repoCell = ReusableCell<RepoCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<TrendingRepoSection>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.minimumInteritemSpacing = 0
        //layout.minimumLineSpacing = 10
        //layout.sectionInset = .init(horizontal: 30, vertical: 20)
        //layout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        return layout
    }

    init(_ navigator: NavigatorType, _ reactor: TrendingRepoListViewReactor) {
        defer {
            self.reactor = reactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
        self.hidesNavigationBar = boolMember(reactor.parameters, Parameter.hideNavBar, true)
        self.shouldRefresh = boolMember(reactor.parameters, Parameter.shouldRefresh, true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(Reusable.repoCell)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - navigationContentTopConstant - tabBarHeight)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).subscribe(onNext: { [weak self] sectionItem in
            guard let `self` = self else { return }
            switch sectionItem {
            case let .repository(item):
                if var url = Router.Repo.detail.pattern.url,
                    let fullname = item.currentState.name {
                    url.appendQueryParameters([Parameter.fullname: fullname])
                    self.navigator.push(url)
                }
                // self.navigator.push(Router.Repo.detail.pattern)
            }
        }).disposed(by: self.disposeBag)
    }

    func bind(reactor: TrendingRepoListViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.refresh.map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading())
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.condition }
            .distinctUntilChanged()
            .skip(1)
            .mapToVoid()
            .bind(to: self.rx.startPullToRefresh)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: TrendingRepoListViewReactor) -> RxCollectionViewSectionedReloadDataSource<TrendingRepoSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .repository(item):
                    let cell = collectionView.dequeue(Reusable.repoCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
        })
    }
}

extension TrendingRepoListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .repository(item):
            return Reusable.repoCell.class.size(width: width, item: item)
        }
    }

}
