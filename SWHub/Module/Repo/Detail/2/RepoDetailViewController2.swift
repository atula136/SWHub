//
//  RepoDetailViewController2.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
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

class RepoDetailViewController2: CollectionViewController, ReactorKit.View {
    struct Reusable {
        static let detailCell = ReusableCell<RepoDetailCell2>()
        static let headerView = ReusableView<RepoDetailHeaderView2>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<RepoDetailSection2>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 20)
        layout.headerReferenceSize = CGSize(width: screenWidth, height: flat(10 + metric(90) + 20 + metric(30) + 10))
        return layout
    }

    init(_ navigator: NavigatorType, _ reactor: RepoDetailViewReactor2) {
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
        self.navigationBar.addButtonToRight(FontAwesomeIcon.githubIcon.image(ofSize: .init(width: 24, height: 24), color: .tint).template).rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.navigator.push("\(UIApplication.shared.baseWebUrl)/\(self.reactor?.fullname ?? "")")
        }).disposed(by: self.disposeBag)
        self.collectionView.register(Reusable.detailCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
    }

    func bind(reactor: RepoDetailViewReactor2) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
//        self.segment.rx.selectedSegmentIndex.skip(1).distinctUntilChanged().map { Reactor.Action.since($0) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//        self.collectionView.rx.itemSelected(dataSource: self.dataSource).map { sectionItem -> String? in
//            switch sectionItem {
//            case let .language(item):
//                if let language = item.model as? Condition.Language {
//                    return language.urlParam
//                }
//                return nil
//            }}.distinctUntilChanged().map { Reactor.Action.language($0) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
            // state
//        reactor.state.map { $0.since.rawValue }
//            .distinctUntilChanged()
//            .ignore(self.segment.selectedSegmentIndex)
//            .bind(to: self.segment.rx.selectedSegmentIndex)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.language.urlParam }
//            .distinctUntilChanged()
//            .bind(to: self.rx.language)
//            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading())
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isActivating }
            .distinctUntilChanged()
            .bind(to: self.rx.activating())
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

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: RepoDetailViewReactor2) -> RxCollectionViewSectionedReloadDataSource<RepoDetailSection2> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                    switch sectionItem {
                    case let .detail(item):
                        let cell = collectionView.dequeue(Reusable.detailCell, for: indexPath)
                        cell.bind(reactor: item)
                        return cell
                    }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
                    view.bind(reactor: RepoDetailHeaderReactor2(reactor.currentState.repository))
                    Observable.merge(view.rx.watchers.asObservable(), view.rx.stargazers.asObservable()).subscribe(onNext: { parameters in
                        if var url = Router.User.list.urlString.url,
                            let fullname = reactor.fullname {
                            url.appendQueryParameters(parameters)
                            url.appendQueryParameters([ Parameter.fullname: fullname ])
                            navigator.push(url)
                        }
                    }).disposed(by: view.disposeBag)
                    view.rx.forks.subscribe(onNext: { parameters in
                        if var url = Router.Repo.list.urlString.url,
                            let fullname = reactor.fullname {
                            url.appendQueryParameters(parameters)
                            url.appendQueryParameters([ Parameter.fullname: fullname ])
                            navigator.push(url)
                        }
                    }).disposed(by: view.disposeBag)
                    view.rx.star.map { Reactor.Action.star($0) }
                        .bind(to: reactor.action)
                        .disposed(by: view.disposeBag)
                    reactor.state.map { $0.starred }
                        .distinctUntilChanged()
                        .bind(to: view.rx.starred)
                        .disposed(by: view.disposeBag)
                    return view
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }
}

extension RepoDetailViewController2: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .detail(item):
            return Reusable.detailCell.class.size(width: width, item: item)
        }
    }

}

extension Reactive where Base: RepoDetailViewController2 {
//    var language: Binder<String?> {
//        return Binder(self.base) { viewController, attr in
//            Condition.Language.event.onNext(.select(attr))
//        }
//    }
}
