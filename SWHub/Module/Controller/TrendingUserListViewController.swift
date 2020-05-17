//
//  TrendingUserListViewController.swift
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

class TrendingUserListViewController: CollectionViewController, ReactorKit.View {

    struct Reusable {
        static let userCell = ReusableCell<UserBasicCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<UserSection>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 10
//        layout.sectionInset = .init(horizontal: 30, vertical: 20)
        return layout
    }

    init(_ navigator: NavigatorType, _ reactor: TrendingUserListViewReactor) {
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
        self.collectionView.register(Reusable.userCell)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - navigationContentTopConstant - tabBarHeight)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).subscribe(onNext: { [weak self] sectionItem in
            guard let `self` = self else { return }
            switch sectionItem {
            case let .basic(item):
//                if var url = Router.User.detail.urlString.url,
//                    let username = (item.model as? TrendingUser)?.username {
//                    url.appendQueryParameters([Parameter.username: username])
//                    self.navigator.push(url)
//                }
                print("")
            default: break
            }
        }).disposed(by: self.disposeBag)
    }

    func bind(reactor: TrendingUserListViewReactor) {
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
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: TrendingUserListViewReactor) -> RxCollectionViewSectionedReloadDataSource<UserSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .basic(item):
                    let cell = collectionView.dequeue(Reusable.userCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                default: return collectionView.emptyCell(for: indexPath)
                }
        })
    }

}

extension TrendingUserListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .basic(item):
            return Reusable.userCell.class.size(width: width, item: item)
        default: return .zero
        }
    }

}
