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
        static let profileCell = ReusableCell<ProfileCell>()
        static let projectCell = ReusableCell<SettingProjectCell2>()
        static let loginCell = ReusableCell<SettingLoginCell>()
        static let switchCell = ReusableCell<SettingSwitchCell>()
        static let settingCell = ReusableCell<SettingNormalCell>()
        static let headerView = ReusableView<SettingHeaderView>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<SettingSection>

//    override var layout: UICollectionViewLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 10
//        layout.sectionInset = .init(horizontal: 30, vertical: 0)
//        layout.headerReferenceSize = CGSize(width: screenWidth, height: metric(30))
//        return layout
//    }

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
        self.collectionView.register(Reusable.profileCell)
        self.collectionView.register(Reusable.projectCell)
        self.collectionView.register(Reusable.loginCell)
        self.collectionView.register(Reusable.switchCell)
        self.collectionView.register(Reusable.settingCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).subscribe(onNext: { [weak self] item in
            guard let `self` = self else { return }
            switch item {
            case .login:
                self.navigator.present(Router.login.pattern, wrap: NavigationController.self)
            case .logout:
                if let navigator = self.navigator as? Navigator,
                    var url = Router.alert.pattern.url {
                    url.appendQueryParameters([
                        Parameter.title: self.reactor?.currentState.user?.login ?? "",
                        Parameter.message: R.string.localizable.userExitPrompt(UIApplication.shared.displayName ?? "")
                    ])
                    navigator.rx.open(url, context: [AlertAction.cancel, AlertAction.destructive]).subscribe(onNext: { action in
                        if let action = action as? AlertAction,
                            action == .destructive {
                            User.update(nil)
                        }
                    }).disposed(by: self.disposeBag)
                }
            case .color:
                self.navigator.push(Router.color.pattern)
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        themeService.rx
            .bind({ $0.primaryColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

    func bind(reactor: SettingViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isNight }
            .distinctUntilChanged()
            .bind(to: self.rx.night)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: SettingViewReactor) -> RxCollectionViewSectionedReloadDataSource<SettingSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .profile(item):
                    let cell = collectionView.dequeue(Reusable.profileCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case let .project(item):
                    let cell = collectionView.dequeue(Reusable.projectCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case let .login(item):
                    let cell = collectionView.dequeue(Reusable.loginCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case .night(let item):
                    let cell = collectionView.dequeue(Reusable.switchCell, for: indexPath)
                    cell.bind(reactor: item)
                    cell.rx.switched.distinctUntilChanged().skip(1).map { Reactor.Action.night($0) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    return cell
                case .logout(let item), .color(let item), .cache(let item):
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
                        .map { _ in }
                        .bind(to: view.rx.setNeedsLayout)
                        .disposed(by: view.disposeBag)
                    return view
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }

    enum AlertAction: AlertActionType, Equatable {
        case `default`
        case cancel
        case destructive

        var title: String? {
            switch self {
            case .default:      return R.string.localizable.yes()
            case .cancel:       return R.string.localizable.cancel()
            case .destructive:  return R.string.localizable.exit()
            }
        }

        var style: UIAlertAction.Style {
            switch self {
            case .default:      return .default
            case .cancel:       return .cancel
            case .destructive:  return .destructive
            }
        }

        static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
            switch (lhs, rhs) {
            case (.default, .default), (.cancel, .cancel), (.destructive, .destructive):
                return true
            default:
                return false
            }
        }
    }

}

extension SettingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .profile(item):
            return Reusable.profileCell.class.size(width: width, item: item)
        case let .project(item):
            return Reusable.projectCell.class.size(width: width, item: item)
        case let .login(item):
            return Reusable.loginCell.class.size(width: width, item: item)
        case let .night(item):
            return Reusable.switchCell.class.size(width: width, item: item)
        case .logout(let item), .color(let item), .cache(let item):
            return Reusable.settingCell.class.size(width: width, item: item)
        }
    }
}

extension Reactive where Base: SettingViewController {

    var night: Binder<Bool> {
        return Binder(self.base) { _, attr in
            var theme = ThemeType.currentTheme()
            if theme.isDark != attr {
                theme = theme.toggled()
            }
            themeService.switch(theme)
            Setting.event.onNext(.night(attr))
        }
    }
}
