//
//  ProfileInfoView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SWFrame

class ProfileInfoView: UIView {

    lazy var gesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()

    lazy var titleLabel: Label = {
        let label = Label()
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        return imageView
    }()

    lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.indicator.template
        imageView.sizeToFit()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderPosition = .bottom
        self.qmui_borderWidth = pixelOne
        self.addGestureRecognizer(self.gesture)

        self.addSubview(self.titleLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.indicatorImageView)
        themeService.rx
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.backgroundColor }, to: self.rx.backgroundColor)
            .bind({ $0.titleColor }, to: self.titleLabel.rx.textColor)
            .bind({ $0.tintColor }, to: [self.iconImageView.rx.tintColor, self.indicatorImageView.rx.tintColor])
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.sizeToFit()
        self.iconImageView.left = 20
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.indicatorImageView.right = self.width - 20
        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.iconImageView.right + 10
        self.titleLabel.extendToRight = self.indicatorImageView.left - 10
        self.titleLabel.top = self.titleLabel.topWhenCenter
    }

}

extension Reactive where Base: ProfileInfoView {
    var tap: ControlEvent<Void> {
        let source = self.base.gesture.rx.event.map { _ in }
        return ControlEvent(events: source)
    }
}
