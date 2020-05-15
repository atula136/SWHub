//
//  TintViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
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

class TintViewController: CollectionViewController, ReactorKit.View {

    struct Reusable {
        static let colorCell = ReusableCell<TintCell>()
    }

    let dataSource: RxCollectionViewSectionedReloadDataSource<TintSection>

    override var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(horizontal: 30, vertical: 0)
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 10)
        return layout
    }

    init(_ navigator: NavigatorType, _ reactor: TintViewReactor) {
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
        self.collectionView.register(Reusable.colorCell)

        self.collectionView.rx.itemSelected(dataSource: self.dataSource).subscribe(onNext: { sectionItem in
            switch sectionItem {
            case let .color(item):
                if let color = item.model as? Tint, !color.checked() {
                    let theme = ThemeType.currentTheme().withColor(color: color.id!)
                    themeService.switch(theme)
                    Tint.event.onNext(.updateColor(color.id!))
                }
            }
        }).disposed(by: self.disposeBag)

        themeService.rx
            .bind({ $0.dimColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

    func bind(reactor: TintViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.viewDidLoad.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    static func dataSourceFactory(_ navigator: NavigatorType, _ reactor: TintViewReactor) -> RxCollectionViewSectionedReloadDataSource<TintSection> {
        return .init(
            configureCell: { dataSource, collectionView, indexPath, sectionItem in
                switch sectionItem {
                case let .color(item):
                    let cell = collectionView.dequeue(Reusable.colorCell, for: indexPath)
                    cell.bind(reactor: item)
                    return cell
                }
            }
        )
    }
}

extension TintViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case let .color(item):
            return Reusable.colorCell.class.size(width: width, item: item)
        }
    }

}
