//
//  ConditionViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
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

class ConditionViewController: CollectionViewController, ReactorKit.View {
    struct Reusable {
        static let languageCell = ReusableCell<Condition.Language.Cell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<Condition.Language.Section>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 20)
        return layout
    }

    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Condition.Since.allValues.map { $0.title })
        for index in 0..<segment.numberOfSegments {
            segment.setWidth(60, forSegmentAt: index)
        }
        segment.sizeToFit()
        return segment
    }()

    init(_ navigator: NavigatorType, _ reactor: ConditionViewReactor) {
        defer {
            self.reactor = reactor
        }
        self.dataSource = type(of: self).dataSourceFactory(navigator, reactor)
        super.init(navigator, reactor)
        // self.hidesNavigationBar = boolMember(reactor.parameters, Parameter.hideNavBar, true)
        // self.shouldRefresh = boolMember(reactor.parameters, Parameter.shouldRefresh, true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = self.navigationBar.addButtonToRight(nil, R.string.localizable.save())
        saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            var condition = Condition.init()
            condition.since = self.reactor!.currentState.since
            condition.language = self.reactor!.currentState.language
            Condition.update(condition)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        self.navigationBar.titleView = self.segment

        self.collectionView.register(Reusable.languageCell)

        themeService.rx
            .bind({ [NSAttributedString.Key.foregroundColor: $0.headColor] }, to: self.segment.rx.titleTextAttributes(for: .normal))
            .bind({ [NSAttributedString.Key.foregroundColor: $0.foregroundColor] }, to: self.segment.rx.titleTextAttributes(for: .selected))
            .disposed(by: self.rx.disposeBag)
    }

    func bind(reactor: ConditionViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.rx.emptyDataSet.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.segment.rx.selectedSegmentIndex.skip(1).distinctUntilChanged().map { Reactor.Action.since($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).map { sectionItem -> String? in
            switch sectionItem {
            case let .language(item):
                if let language = item.model as? Condition.Language {
                    return language.urlParam
                }
                return nil
            }}.distinctUntilChanged().map { Reactor.Action.language($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.since.rawValue }
            .distinctUntilChanged()
            .ignore(self.segment.selectedSegmentIndex)
            .bind(to: self.segment.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.language.urlParam }
            .distinctUntilChanged()
            .bind(to: self.rx.language)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading())
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: ConditionViewReactor) -> RxCollectionViewSectionedReloadDataSource<Condition.Language.Section> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .language(item):
                    let cell = collectionView.dequeue(Reusable.languageCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
        })
    }
}

extension ConditionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .language(item):
            return Reusable.languageCell.class.size(width: width, item: item)
        }
    }

}

extension Reactive where Base: ConditionViewController {

    var language: Binder<String?> {
        return Binder(self.base) { _, attr in
            Condition.Language.event.onNext(.select(attr))
        }
    }
}
