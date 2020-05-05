//
//  TrendingRepositoryListViewController.swift
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

class TrendingRepositoryListViewController: CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let repositoryCell = ReusableCell<TrendingRepositoryCell>()
    }
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<TrendingRepositorySection>
    
    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 20)
        //layout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        return layout
    }
    
    init(_ navigator: NavigatorType, _ reactor: TrendingRepositoryListViewReactor) {
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
        self.collectionView.register(Reusable.repositoryCell)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - navigationContentTopConstant - tabBarHeight)
    }
    
    func bind(reactor: TrendingRepositoryListViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map{ Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map{ Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.refresh.map{ Reactor.Action.refresh }
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
        reactor.state.map{ $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
//        reactor.state.map{ $0.since }.distinctUntilChanged().skip(1).subscribe(onNext: { since in
//            let abc = self
//            print("")
//        }).disposed(by: self.disposeBag)
//        reactor.state.map{ ($0.since, $0.language) }.skip(1).subscribe(onNext: { (since, language) in
//            print("")
//        }).disposed(by: self.disposeBag)
    }
    
    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: TrendingRepositoryListViewReactor) -> RxCollectionViewSectionedReloadDataSource<TrendingRepositorySection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .repository(item):
                    let cell = collectionView.dequeue(Reusable.repositoryCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
        })
    }
    
}

extension TrendingRepositoryListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .repository(item):
            return Reusable.repositoryCell.class.size(width: width, item: item)
        }
    }

}

