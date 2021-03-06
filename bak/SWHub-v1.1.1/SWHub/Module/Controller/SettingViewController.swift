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
import RealmSwift
import ReusableKit
import Kingfisher
import RxViewController
import RxDataSources
import RxSwiftExt
import SWFrame

class SettingViewController: CollectionViewController, ReactorKit.View {

    struct Reusable {
        static let profileCell = ReusableCell<UserProfileCell>()
        static let loginCell = ReusableCell<SettingLoginCell>()
        static let switchCell = ReusableCell<SettingSwitchCell>()
        static let settingCell = ReusableCell<SettingNormalCell>()
        static let headerView = ReusableView<SettingHeaderView>()
        static let footerView = ReusableView<SettingFooterView>()
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
        self.collectionView.register(Reusable.profileCell)
        self.collectionView.register(Reusable.loginCell)
        self.collectionView.register(Reusable.switchCell)
        self.collectionView.register(Reusable.settingCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
        self.collectionView.register(Reusable.footerView, kind: .footer)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).subscribe(onNext: { [weak self] item in
            guard let `self` = self else { return }
            switch item {
            case .login:
                self.navigator.present(Router.login.urlString, wrap: NavigationController.self)
            case .color:
                self.navigator.push(Router.color.urlString)
            case .cache:
                self.view.makeToastActivity(.center)
                ImageCache.default.clearMemoryCache()
                ImageCache.default.clearDiskCache {
                    Setting.event.onNext(.updateCache)
                    self.view.hideToastActivity()
                    self.view.makeToast(R.string.localizable.cacheClearedSuccessfully())
                }
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        self.collectionView.rx.willDisplayCell.subscribe(onNext: { _, indexPath in
            if indexPath.section == 1 && indexPath.row == 2 {
                Setting.event.onNext(.updateCache)
            }
        }).disposed(by: self.disposeBag)
        self.rx.viewWillAppear.subscribe(onNext: { _ in
            Setting.event.onNext(.updateCache)
        }).disposed(by: self.disposeBag)
        themeService.rx
            .bind({ $0.dimColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if #available(iOS 11.0, *), isNotchedScreen, let parent = self.tabBarController?.tabBar.superview {
//            self.tabBarController?.tabBar.frame = CGRect(x: 0, y: parent.frame.size.height - tabBarHeight, width: parent.frame.size.width, height: tabBarHeight)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if #available(iOS 11.0, *), isNotchedScreen, let parent = self.tabBarController?.tabBar.superview {
//            self.tabBarController?.tabBar.frame = CGRect(x: 0, y: parent.frame.size.height - tabBarHeight, width: parent.frame.size.width, height: tabBarHeight)
//        }
//    }

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
                    cell.rx.blog.subscribe(onNext: { url in
                        navigator.push(url)
                    }).disposed(by: cell.disposeBag)
                    cell.rx.list.subscribe(onNext: { url in
                        navigator.push(url)
                    }).disposed(by: cell.disposeBag)
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
                case .color(let item):
                    let cell = collectionView.dequeue(Reusable.settingCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                case .cache(let item):
                    let cell = collectionView.dequeue(Reusable.settingCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    return collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
                case UICollectionView.elementKindSectionFooter:
                    let footer = collectionView.dequeue(Reusable.footerView, kind: kind, for: indexPath)
                    if let navigator = navigator as? Navigator,
                        var url = Router.alert.urlString.url {
                        url.appendQueryParameters([
                            Parameter.title: reactor.currentState.user?.username ?? "",
                            Parameter.message: R.string.localizable.userExitPrompt(UIApplication.shared.displayName ?? "")
                        ])
                        footer.rx.logout.flatMap { _ -> Observable<AlertActionType> in
                            return navigator.rx.open(url, context: [AlertAction.cancel, AlertAction.destructive])
                        }.map { $0 as? AlertAction }.ignoreWhen { $0 != .destructive }.subscribe(onNext: { _ in
                            User.token = nil
                            User.logout()
                        }).disposed(by: footer.disposeBag)
                    }
                    return footer
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
        case let .login(item):
            return Reusable.loginCell.class.size(width: width, item: item)
        case let .night(item):
            return Reusable.switchCell.class.size(width: width, item: item)
        case .color(let item), .cache(let item):
            return Reusable.settingCell.class.size(width: width, item: item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return CGSize(width: collectionView.sectionWidth(at: section), height: metric(20))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 && self.reactor?.currentState.user != nil {
            return CGSize(width: collectionView.sectionWidth(at: section), height: metric(70))
        }
        return .zero
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
            Setting.event.onNext(.turnNight(attr))
        }
    }
}
