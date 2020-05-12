//
//  SettingFooterView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SwifterSwift
import SWFrame

class SettingFooterView: SupplementaryView {

    var kind: String {
        return UICollectionView.elementKindSectionFooter
    }

    lazy var logoutButton: Button = {
        let button = Button(type: .custom)
        button.titleLabel?.font = .normal(18)
        button.setTitle(R.string.localizable.logout(), for: .normal)
        button.borderWidth = pixelOne
        button.cornerRadius = 3
        button.sizeToFit()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.logoutButton)
        themeService.rx
            .bind({ $0.bgColor }, to: self.logoutButton.rx.backgroundColor)
            .bind({ $0.border1Color }, to: self.logoutButton.rx.borderColor)
            .bind({ $0.titleColor }, to: self.logoutButton.rx.titleColor(for: .normal))
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.logoutButton.width = flat(self.width - metric(30) * 2)
        self.logoutButton.height = metric(44)
        self.logoutButton.left = self.logoutButton.leftWhenCenter
        self.logoutButton.top = self.logoutButton.topWhenCenter
    }

}

extension Reactive where Base: SettingFooterView {
    var logout: ControlEvent<Void> {
        let source = self.base.logoutButton.rx.tap.map { _ in }
        return ControlEvent(events: source)
    }
}
