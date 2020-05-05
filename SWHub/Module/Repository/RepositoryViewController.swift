//
//  RepositoryViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import ReactorKit
import URLNavigator
import Rswift
import SwifterSwift
import SWFrame

class RepositoryViewController: BaseViewController, ReactorKit.View {
    
    init(_ navigator: NavigatorType, _ reactor: RepositoryViewReactor) {
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
    
    func bind(reactor: RepositoryViewReactor) {
        super.bind(reactor: reactor)
    }
    
}
