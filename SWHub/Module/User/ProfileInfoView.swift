//
//  ProfileInfoView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import SWFrame

class ProfileInfoView: UIView {

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
        self.addSubview(self.titleLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.indicatorImageView)
        themeService.rx
            .bind({ $0.borderDarkColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.bgColor }, to: self.rx.backgroundColor)
            .bind({ $0.textDarkColor }, to: self.titleLabel.rx.textColor)
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
