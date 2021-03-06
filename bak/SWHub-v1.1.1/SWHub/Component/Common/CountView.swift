//
//  CountView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SWFrame

class CountView: UIView {

    lazy var firstButton: Button = {
        let button = Button(type: .custom)
        button.tag = 0
        button.titleLabel?.numberOfLines = 0
        return button
    }()

    lazy var secondButton: Button = {
        let button = Button(type: .custom)
        button.tag = 1
        button.titleLabel?.numberOfLines = 0
        return button
    }()

    lazy var thirdButton: Button = {
        let button = Button(type: .custom)
        button.tag = 2
        button.titleLabel?.numberOfLines = 0
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderPosition = .bottom
        self.qmui_borderWidth = pixelOne
        self.addSubview(self.firstButton)
        self.addSubview(self.secondButton)
        self.addSubview(self.thirdButton)
        themeService.rx
            .bind({ $0.backgroundColor }, to: self.rx.backgroundColor)
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: screenWidth, height: metric(50))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.firstButton.width = self.width / 3.f
        self.firstButton.height = self.height
        self.firstButton.left = 0
        self.firstButton.top = 0
        self.secondButton.width = self.firstButton.width
        self.secondButton.height = self.firstButton.height
        self.secondButton.left = self.firstButton.right
        self.secondButton.top = 0
        self.thirdButton.width = self.firstButton.width
        self.thirdButton.height = self.firstButton.height
        self.thirdButton.left = self.secondButton.right
        self.thirdButton.top = 0
    }

}

extension Reactive where Base: CountView {

    var counts: Binder<[NSAttributedString]> {
        return Binder(self.base) { view, attrs in
            if attrs.count >= 3 {
                view.firstButton.setAttributedTitle(attrs[0], for: .normal)
                view.secondButton.setAttributedTitle(attrs[1], for: .normal)
                view.thirdButton.setAttributedTitle(attrs[2], for: .normal)
            } else {
                view.firstButton.setAttributedTitle(nil, for: .normal)
                view.secondButton.setAttributedTitle(nil, for: .normal)
                view.thirdButton.setAttributedTitle(nil, for: .normal)
            }
            view.setNeedsLayout()
        }
    }

    var tap: ControlEvent<ListType> {
        let source = ControlEvent.merge(self.base.firstButton.rx.tap.map { ListType.repositories }, self.base.secondButton.rx.tap.map { ListType.followers }, self.base.thirdButton.rx.tap.map { ListType.following })
        return ControlEvent(events: source)
    }

}
