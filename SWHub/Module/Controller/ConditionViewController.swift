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
import RealmSwift
import ReactorKit
import ReusableKit
import RxDataSources
import SWFrame

class ConditionViewController: CollectionViewController, ReactorKit.View {
    struct Reusable {
        static let codeCell = ReusableCell<ConditionCodeCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<ConditionSection>

    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Since.allValues.map { $0.title })
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = self.navigationBar.addButtonToRight(nil, R.string.localizable.save())
        saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let since = self.reactor!.currentState.since
            let code = self.reactor!.currentState.code
            let config = Config.current!
            let realm = Realm.default
            realm.beginWrite()
            config.since = since.rawValue
            config.codeId = code.id
            try! realm.commitWrite()
            Condition.event.onNext(.update(since, code))
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

        self.navigationBar.titleView = self.segment
        self.collectionView.register(Reusable.codeCell)

        themeService.rx
            .bind({ [NSAttributedString.Key.foregroundColor: $0.titleColor] }, to: self.segment.rx.titleTextAttributes(for: .normal))
            .bind({ [NSAttributedString.Key.foregroundColor: $0.backgroundColor] }, to: self.segment.rx.titleTextAttributes(for: .selected))
            .disposed(by: self.rx.disposeBag)
    }

    func bind(reactor: ConditionViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.segment.rx.selectedSegmentIndex.skip(1).distinctUntilChanged().map { Reactor.Action.since($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.collectionView.rx.itemSelected(dataSource: self.dataSource).map { sectionItem -> String? in
            switch sectionItem {
            case let .code(item):
                if let code = item.model as? Code {
                    return code.id
                }
                return nil
            }}.distinctUntilChanged().map { Reactor.Action.code($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.since.rawValue }
            .distinctUntilChanged()
            .ignore(self.segment.selectedSegmentIndex)
            .bind(to: self.segment.rx.selectedSegmentIndex)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.code.id }
            .distinctUntilChanged()
            .bind(to: self.rx.code)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: ConditionViewReactor) -> RxCollectionViewSectionedReloadDataSource<ConditionSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .code(item):
                    let cell = collectionView.dequeue(Reusable.codeCell, for: indexPath)
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
        case let .code(item):
            return Reusable.codeCell.class.size(width: width, item: item)
        }
    }

}

extension Reactive where Base: ConditionViewController {

    var code: Binder<String?> {
        return Binder(self.base) { _, attr in
            let code = Code(value: ["id": attr])
            Subjection.for(Code.self).accept(code)
        }
    }
}
