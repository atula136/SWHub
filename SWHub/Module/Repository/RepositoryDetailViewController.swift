//
//  RepositoryDetailViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import URLNavigator
import ReactorKit
import ReusableKit
import RxDataSources
import SWFrame

class RepositoryDetailViewController: CollectionViewController, ReactorKit.View {
    
    struct Reusable {
        static let detailCell = ReusableCell<RepositoryDetailCell>()
        static let headerView = ReusableView<RepositoryDetailHeaderView>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<RepositoryDetailSection>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 20)
        layout.headerReferenceSize = CGSize(width: screenWidth, height: flat(10 + metric(90) + 20 + metric(30) + 10))
        return layout
    }
    
    init(_ navigator: NavigatorType, _ reactor: RepositoryDetailViewReactor) {
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
//        let saveButton = self.navigationBar.addButtonToRight(nil, R.string.localizable.commonSave())
//        saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
//            guard let `self` = self else { return }
//            var condition = Condition.init()
//            condition.since = self.reactor!.currentState.since
//            condition.language = self.reactor!.currentState.language
//            Condition.update(condition)
//            self.dismiss(animated: true, completion: nil)
//        }).disposed(by: self.disposeBag)
//        self.navigationBar.titleView = self.segment
//
        self.collectionView.register(Reusable.detailCell)
        self.collectionView.register(Reusable.headerView, kind: .header)
    }
    
    func bind(reactor: RepositoryDetailViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map{ Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map{ Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
//        self.segment.rx.selectedSegmentIndex.skip(1).distinctUntilChanged().map{ Reactor.Action.since($0) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//        self.collectionView.rx.itemSelected(dataSource: self.dataSource).map { sectionItem -> String? in
//            switch sectionItem {
//            case let .language(item):
//                if let language = item.model as? Condition.Language {
//                    return language.urlParam
//                }
//                return nil
//            }}.distinctUntilChanged().map{ Reactor.Action.language($0) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
            // state
//        reactor.state.map { $0.since.rawValue }
//            .distinctUntilChanged()
//            .ignore(self.segment.selectedSegmentIndex)
//            .bind(to: self.segment.rx.selectedSegmentIndex)
//            .disposed(by: self.disposeBag)
//        reactor.state.map{ $0.language.urlParam }
//            .distinctUntilChanged()
//            .bind(to: self.rx.language)
//            .disposed(by: self.disposeBag)
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
        reactor.state.map{ $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: RepositoryDetailViewReactor) -> RxCollectionViewSectionedReloadDataSource<RepositoryDetailSection> {
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
                    view.bind(reactor: RepositoryDetailHeaderReactor(reactor.currentState.repository))
                    return view
                default:
                    return collectionView.emptyView(for: indexPath, kind: kind)
                }
            }
        )
    }
    
}

extension RepositoryDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .detail(item):
            return Reusable.detailCell.class.size(width: width, item: item)
        }
    }

}

extension Reactive where Base: RepositoryDetailViewController {
    
//    var language: Binder<String?> {
//        return Binder(self.base) { viewController, attr in
//            Condition.Language.event.onNext(.select(attr))
//        }
//    }
    
}
