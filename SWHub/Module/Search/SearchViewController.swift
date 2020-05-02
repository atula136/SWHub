//
//  SearchViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import URLNavigator
import Rswift
import SwifterSwift
import SWFrame

class SearchViewController: BaseViewController, ReactorKit.View {
    
    init(_ navigator: NavigatorType, _ reactor: SearchViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.currentState.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let item = self.tabBarItem {
//            themeService.rx
//                .bind({ [NSAttributedString.Key.foregroundColor: $0.highlightedColor] }, to: item.rx.titleTextAttributes(for: .normal))
//                // .bind({ [NSAttributedString.Key.foregroundColor: $0.foregroundColor] }, to: item.rx.titleTextAttributes(for: .selected))
//                .disposed(by: self.rx.disposeBag)
//        }
    }
    
    func bind(reactor: SearchViewReactor) {
        super.bind(reactor: reactor)
    }
    
}
