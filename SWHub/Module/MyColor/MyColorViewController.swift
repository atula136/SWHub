//
//  MyColorViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import URLNavigator
import Rswift
import SwifterSwift
import SWFrame

class MyColorViewController: BaseViewController, ReactorKit.View {
    
    init(_ navigator: NavigatorType, _ reactor: MyColorViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: MyColorViewReactor) {
        super.bind(reactor: reactor)
        // state
        reactor.state.map { $0.title }
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

