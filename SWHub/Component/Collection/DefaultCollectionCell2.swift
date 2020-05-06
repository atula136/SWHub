//
//  DefaultCollectionCell2.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
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

class DefaultCollectionCell2: CollectionCell {
    
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
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.indicator.template
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.sizeToFit()
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        
        self.iconImageView.height = flat(frame.size.height * 0.6)
        self.iconImageView.width = self.iconImageView.height
        self.contentView.addSubview(self.iconImageView)
        
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.accessoryImageView)
        self.contentView.addSubview(self.switcher)
        
        themeService.rx
            .bind({ $0.textColor }, to: [self.titleLabel.rx.textColor, self.detailLabel.rx.textColor])
            .bind({ $0.foregroundColor }, to: [self.iconImageView.rx.tintColor, self.accessoryImageView.rx.tintColor])
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
        self.avatarImageView.image = nil
        self.accessoryImageView.image = nil
        self.switcher.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.accessoryImageView.top = self.accessoryImageView.topWhenCenter
        self.accessoryImageView.right = self.contentView.width - 15
        
        self.switcher.right = self.accessoryImageView.right
        self.switcher.top = self.switcher.topWhenCenter
        
        self.iconImageView.left = 15
        self.iconImageView.top = self.iconImageView.topWhenCenter
        
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.iconImageView.isHidden ? self.iconImageView.left : self.iconImageView.right + 10.f
        self.titleLabel.top = self.titleLabel.topWhenCenter
        
        self.detailLabel.sizeToFit()
        self.detailLabel.top = self.detailLabel.topWhenCenter
        if self.accessoryImageView.isHidden {
            self.detailLabel.right = self.accessoryImageView.right
        } else {
            self.detailLabel.right = self.accessoryImageView.left - 8
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
    
}

extension Reactive where Base: DefaultCollectionCell2 {
    var switched: ControlEvent<Bool> {
        return ControlEvent(events: self.base.switcher.rx.value)
    }
}

