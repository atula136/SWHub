//
//  NormalCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/1.
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

class NormalCell: CollectionCell, ReactorKit.View {
    
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
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var avatarImageView: UIImageView = {
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
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.indicatorImageView)
        
        themeService.rx
            .bind({ $0.textColor }, to: [self.titleLabel.rx.textColor, self.detailLabel.rx.textColor])
            .bind({ $0.secondaryColor }, to: [self.iconImageView.rx.tintColor, self.indicatorImageView.rx.tintColor])
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.detailLabel.text = nil
        self.iconImageView.image = nil
        self.avatarImageView.image = nil
        self.indicatorImageView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
        self.indicatorImageView.right = self.contentView.width - 15
        
        self.iconImageView.sizeToFit()
        if self.iconImageView.isHidden {
            self.iconImageView.frame = .zero
        }
        self.iconImageView.left = 15
        self.iconImageView.top = self.iconImageView.topWhenCenter
        
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.iconImageView.right + (self.iconImageView.isHidden ? 0.f : 10.f)
        self.titleLabel.top = self.titleLabel.topWhenCenter
        
        self.detailLabel.sizeToFit()
        self.detailLabel.top = self.detailLabel.topWhenCenter
        if self.indicatorImageView.isHidden {
            self.detailLabel.right = self.indicatorImageView.right
        } else {
            self.detailLabel.right = self.indicatorImageView.left - 8
        }
        
        if self.avatarImageView.isHidden {
            self.avatarImageView.frame = .zero
        } else {
            self.avatarImageView.sizeToFit()
            self.avatarImageView.height = flat(self.contentView.height * 0.6)
            self.avatarImageView.width = self.avatarImageView.height
            self.avatarImageView.top = self.avatarImageView.topWhenCenter
            self.avatarImageView.right = self.detailLabel.left - 8
            self.avatarImageView.cornerRadius = self.avatarImageView.height / 2.0
        }
    }
    
    func bind(reactor: NormalItem) {
        super.bind(item: reactor)
        reactor.state.map{ !$0.indicated }
            .bind(to: self.indicatorImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.title }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.detail }
            .bind(to: self.detailLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.icon }
            .bind(to: self.iconImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.icon == nil }
            .bind(to: self.iconImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map{ _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
}
