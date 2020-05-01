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
        static let userCell = ReusableCell<SettingUserCell>()
        static let projectCell = ReusableCell<SettingProjectCell>()
        static let settingCell = ReusableCell<SettingCell>()
        static let headerView = ReusableView<SettingHeaderView>()
    }
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<SettingSection>
    
    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 0)
        layout.headerReferenceSize = CGSize(width: screenWidth, height: metric(30))
        return layout
    }
    
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
        self.collectionView.register(Reusable.projectCell)
        self.collectionView.register(Reusable.settingCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
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
                case let .project(item):
                    let cell = collectionView.dequeue(Reusable.projectCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case .night(let item):
                    let cell = collectionView.dequeue(Reusable.settingCell, for: indexPath)
                    cell.bind(reactor: item)
                    cell.rx.switched.subscribe(onNext: { isDark in
                        var theme = ThemeType.currentTheme()
                        if theme.isDark != isDark {
                            theme = theme.toggled()
                        }
                        themeService.switch(theme)
                    }).disposed(by: cell.disposeBag)
                    return cell
                case .logout(let item), .theme(let item):
                    let cell = collectionView.dequeue(Reusable.settingCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
                    reactor.state.map { $0.sections[indexPath.section].header }
                        .distinctUntilChanged()
                        .bind(to: view.titleLabel.rx.text)
                        .disposed(by: view.disposeBag)
                    reactor.state.map { $0.sections[indexPath.section].header }
                        .distinctUntilChanged()
                        .map{ _ in }
                        .bind(to: view.rx.setNeedsLayout)
                        .disposed(by: view.disposeBag)
                    return view
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }
    
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .user(item):
            return Reusable.userCell.class.size(width: width, item: item)
        case let .project(item):
            return Reusable.projectCell.class.size(width: width, item: item)
        case .logout(let item), .night(let item), .theme(let item):
            return Reusable.settingCell.class.size(width: width, item: item)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width = collectionView.sectionWidth(at: section)
//        return CGSize(width: width, height: metric(30))
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .init(horizontal: 30, vertical: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
}
