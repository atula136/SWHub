//
//  ConditionCodeCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/12.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import Kingfisher
import ObjectMapper
import SwifterSwift
import Rswift
import SWFrame

class ConditionCodeCell: CollectionCell, ReactorKit.View {

    lazy var titleLabel: Label = {
        let label = Label()
        label.font = .normal(16)
        label.sizeToFit()
        return label
    }()

    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.check.template
        imageView.sizeToFit()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderPosition = .bottom
        self.qmui_borderWidth = pixelOne

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkImageView)

        themeService.rx
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.titleColor }, to: self.titleLabel.rx.textColor)
            .bind({ $0.tintColor }, to: self.checkImageView.rx.tintColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.left = 15
        self.titleLabel.top = self.titleLabel.topWhenCenter

        self.checkImageView.right = self.contentView.width - 15
        self.checkImageView.top = self.checkImageView.topWhenCenter
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.checkImageView.isHidden = true
    }

    func bind(reactor: ConditionCodeItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.title }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { !$0.checked }
            .bind(to: self.checkImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        return CGSize(width: width, height: metric(50))
    }
}
