//
//  SupplementaryView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import SWFrame

class SupplementaryView: BaseSupplementaryView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        themeService.rx
            .bind({ $0.dimColor }, to: self.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
