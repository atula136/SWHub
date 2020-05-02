//
//  SettingUserCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import Kingfisher
import SWFrame

class SettingUserCell: RepositoryCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgeImageView.image = R.image.setting_badge_user()?.template
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//    lazy var titleLabel: Label = {
//        let label = Label()
//        label.font = .normal(14)
//        label.textColor = .black
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var detailLabel: Label = {
//        let label = Label()
//        label.font = .bold(11)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var iconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//    lazy var badgeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .white
//        imageView.tintColor = UIColor.Material.green900
//        imageView.image = R.image.setting_badge_user()?.template
//        imageView.sizeToFit()
//        imageView.size = CGSize(width: 20, height: 20)
//        imageView.borderColor = .white
//        imageView.borderWidth = 1
//        imageView.cornerRadius = 10
//        return imageView
//    }()
//
//    public lazy var indicatorImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.indicator.template
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.cornerRadius = 6
//
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.detailLabel)
//
//        self.iconImageView.height = flat(frame.size.height * 0.8)
//        self.iconImageView.width = self.iconImageView.height
//        self.iconImageView.cornerRadius = self.iconImageView.width / 2.0
//        self.contentView.addSubview(self.iconImageView)
//
//        self.contentView.addSubview(self.badgeImageView)
//        self.contentView.addSubview(self.indicatorImageView)
//
//        themeService.rx
//            .bind({ $0.foregroundColor }, to: self.indicatorImageView.rx.tintColor)
//            .disposed(by: self.disposeBag)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.titleLabel.text = nil
//        self.detailLabel.attributedText = nil
//        self.iconImageView.image = nil
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.iconImageView.left = 10
//        self.iconImageView.top = self.iconImageView.topWhenCenter
//        self.badgeImageView.left = self.iconImageView.left
//        self.badgeImageView.bottom = self.iconImageView.bottom
//
//        self.titleLabel.sizeToFit()
//        self.titleLabel.left = self.iconImageView.right + 8
//        self.titleLabel.bottom = self.contentView.height / 2.0
//
//        self.detailLabel.sizeToFit()
//        self.detailLabel.left = self.titleLabel.left
//        self.detailLabel.top = self.titleLabel.bottom + 6
//
//        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
//        self.indicatorImageView.right = self.contentView.width - 15
//    }
//
//    func bind(reactor: SettingUserItem) {
//        super.bind(item: reactor)
//        reactor.state.map{ $0.title }
//            .bind(to: self.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map{ $0.detail }
//            .bind(to: self.detailLabel.rx.attributedText)
//            .disposed(by: self.disposeBag)
//        reactor.state.map{ $0.detail == nil }
//            .bind(to: self.detailLabel.rx.isHidden)
//            .disposed(by: self.disposeBag)
//        reactor.state.map{ $0.icon }
//            .bind(to: self.iconImageView.rx.image)
//            .disposed(by: self.disposeBag)
//        reactor.state.map{ _ in }
//            .bind(to: self.rx.setNeedsLayout)
//            .disposed(by: self.disposeBag)
//    }
//
//    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
//        return CGSize(width: width, height: metric(70))
//    }
    
}

