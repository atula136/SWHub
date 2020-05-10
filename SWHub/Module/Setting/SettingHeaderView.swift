//
//  SettingHeaderView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import SwifterSwift
import SWFrame

class SettingHeaderView: SupplementaryView {

    lazy var titleLabel: Label = {
        let label = Label()
        label.font = .normal(16)
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        themeService.rx
            .bind({ $0.headColor }, to: self.titleLabel.rx.textColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.left = 15
        self.titleLabel.top = self.titleLabel.topWhenCenter
    }

}
