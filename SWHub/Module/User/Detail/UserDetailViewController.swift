//
//  UserDetailViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/14.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import Iconic
import URLNavigator
import ReactorKit
import ReusableKit
import RxDataSources
import SWFrame

class UserDetailViewController: CollectionViewController, ReactorKit.View {
    struct Reusable {
        static let profileCell = ReusableCell<UserProfileCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<UserSection>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        return layout
    }

    init(_ navigator: NavigatorType, _ reactor: UserDetailViewReactor) {
        defer {
            self.reactor = reactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.addButtonToRight(FontAwesomeIcon.githubIcon.image(ofSize: .init(width: 24, height: 24), color: .tint).template).rx.tap.subscribe(onNext: { [weak self] _ in
//            guard let `self` = self else { return }
//            self.navigator.push("\(UIApplication.shared.baseWebUrl)/\(self.reactor?.fullname ?? "")")
//        }).disposed(by: self.disposeBag)
        self.collectionView.register(Reusable.profileCell)
        themeService.rx
            .bind({ $0.dimColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

    func bind(reactor: UserDetailViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading())
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.title }
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: UserDetailViewReactor) -> RxCollectionViewSectionedReloadDataSource<UserSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .profile(item):
                    let cell = collectionView.dequeue(Reusable.profileCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
        })
    }
}

extension UserDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .profile(item):
            return Reusable.profileCell.class.size(width: width, item: item)
        }
    }

}

extension Reactive where Base: UserDetailViewController {
//    var language: Binder<String?> {
//        return Binder(self.base) { viewController, attr in
//            Condition.Language.event.onNext(.select(attr))
//        }
//    }
}
