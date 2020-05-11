//
//  DefaultCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SwifterSwift
import SWFrame

class DefaultCell: CollectionCell {

    lazy var titleLabel: Label = {
        let label = Label()
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var detailLabel: Label = {
        let label = Label()
        label.font = .normal(13)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()

    lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.indicator.template
        imageView.sizeToFit()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.iconImageView.height = flat(frame.size.height * 0.5)
        self.iconImageView.width = self.iconImageView.height
        self.contentView.addSubview(self.iconImageView)

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.accessoryImageView)

        themeService.rx
            .bind({ $0.headColor }, to: [self.titleLabel.rx.textColor, self.detailLabel.rx.textColor])
            .bind({ $0.tintColor }, to: [self.iconImageView.rx.tintColor, self.accessoryImageView.rx.tintColor])
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.detailLabel.text = nil
        self.iconImageView.image = nil
        self.accessoryImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.left = 15
        self.iconImageView.top = self.iconImageView.topWhenCenter

        self.accessoryImageView.right = self.contentView.width - 15
        self.accessoryImageView.top = self.accessoryImageView.topWhenCenter

        self.titleLabel.sizeToFit()
        self.titleLabel.top = self.titleLabel.topWhenCenter
        self.titleLabel.left = self.iconImageView.isHidden ? self.iconImageView.left : self.iconImageView.right + 10.f

        self.detailLabel.sizeToFit()
        self.detailLabel.top = self.detailLabel.topWhenCenter
        self.detailLabel.right = self.accessoryImageView.isHidden ? self.accessoryImageView.right : self.accessoryImageView.left - 8
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        return CGSize(width: width, height: metric(50))
    }

}
