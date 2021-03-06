//
//  InfoView.swift
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

class InfoView: UIView {

    lazy var gesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()

    lazy var titleLabel: Label = {
        let label = Label()
        label.setContentHuggingPriority(251, for: .horizontal)
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var detailLabel: Label = {
        let label = Label()
        label.font = .normal(14)
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
        self.addSubview(self.detailLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.indicatorImageView)
        themeService.rx
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.backgroundColor }, to: self.rx.backgroundColor)
            .bind({ $0.titleColor }, to: self.titleLabel.rx.textColor)
            .bind({ $0.contentColor }, to: self.detailLabel.rx.textColor)
            .bind({ $0.tintColor }, to: [self.iconImageView.rx.tintColor, self.indicatorImageView.rx.tintColor])
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: screenWidth, height: metric(44))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.sizeToFit()
        self.iconImageView.left = Constant.Metric.margin
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.indicatorImageView.right = self.width - Constant.Metric.margin
        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.iconImageView.right + 10
        self.titleLabel.top = self.titleLabel.topWhenCenter
        self.detailLabel.sizeToFit()
        self.detailLabel.right = self.indicatorImageView.left - 10
        self.detailLabel.top = self.detailLabel.topWhenCenter
    }

}

extension Reactive where Base: InfoView {

    var info: Binder<InfoModel?> {
        return Binder(self.base) { view, info in
            view.iconImageView.image = info?.icon
            view.titleLabel.text = info?.title
            view.detailLabel.text = info?.detail
            view.indicatorImageView.isHidden = !(info?.indicated ?? false)
            view.isHidden = info?.title?.isEmpty ?? true
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    var tap: ControlEvent<Void> {
        let source = self.base.gesture.rx.event.map { _ in }
        return ControlEvent(events: source)
    }

}
