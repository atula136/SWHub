//
//  SettingViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import SwifterSwift
import ReusableKit
import RxViewController
import RxDataSources
import SWFrame

class SettingViewController: CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let userCell = ReusableCell<UserCell>()
        static let logoutCell = ReusableCell<LogoutCell>()
    }
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<SettingSection>
    
    init(_ navigator: NavigatorType, _ reactor: SettingViewReactor) {
        defer {
            self.reactor = reactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.currentState.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(Reusable.userCell)
        self.collectionView.register(Reusable.logoutCell)
        themeService.rx
            .bind({ $0.primaryColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.disposeBag)
    }
    
    func bind(reactor: SettingViewReactor) {
        super.bind(reactor: reactor)
        // action
        Observable.merge(
            self.rx.viewDidLoad.asObservable(),
            self.rx.emptyDataSet.asObservable()
        ).map{ Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: SettingViewReactor) -> RxCollectionViewSectionedReloadDataSource<SettingSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .user(item):
                    let cell = collectionView.dequeue(Reusable.userCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case let .logout(item):
                    let cell = collectionView.dequeue(Reusable.logoutCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
        })
    }
    
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section) - 30
        switch self.dataSource[indexPath] {
        case let .user(item):
            return Reusable.userCell.class.size(width: width, item: item)
        case let .logout(item):
            return Reusable.logoutCell.class.size(width: width, item: item)
        }
    }
    
}
