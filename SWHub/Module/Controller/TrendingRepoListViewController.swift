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
        static let repoCell = ReusableCell<RepoBasicCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<RepoSection>

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
            case let .basic(item):
                if var url = Router.Repo.detail.urlString.url,
                    let fullname = item.currentState.name {
                    url.appendQueryParameters([Parameter.username: fullname])
                    self.navigator.push(url)
                }
            default: break
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
        Observable.combineLatest(reactor.state.map { $0.since }, reactor.state.map { $0.code }).distinctUntilChanged { arg0, arg1 -> Bool in
            let first = arg0.0 == arg0.0
            let second = arg0.1.id == arg1.1.id
            return first && second
        }.skip(1).mapToVoid()
            .bind(to: self.rx.startPullToRefresh)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: TrendingRepoListViewReactor) -> RxCollectionViewSectionedReloadDataSource<RepoSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .basic(item):
                    let cell = collectionView.dequeue(Reusable.repoCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                default: return collectionView.emptyCell(for: indexPath)
                }
        })
    }
}

extension TrendingRepoListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .basic(item):
            return Reusable.repoCell.class.size(width: width, item: item)
        default: return .zero
        }
    }

}
