//
//  ActivityViewController.swift
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

class ActivityViewController: BaseViewController, ReactorKit.View {
    
    init(_ navigator: NavigatorType, _ reactor: ActivityViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
        self.tabBarItem.title = reactor.currentState.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: ActivityViewReactor) {
        super.bind(reactor: reactor)
    }
    
}
