//
//  SettingCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class SettingCell: NormalCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    lazy var titleLabel: Label = {
//        let label = Label()
//        label.font = .normal(14)
//        label.textColor = .black
//        label.sizeToFit()
//        return label
//    }()
//
//    public lazy var indicatorImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.indicator.template
//        imageView.tintColor = .gray
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.cornerRadius = 6
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.indicatorImageView)
//        themeService.rx
//            .bind({ $0.foregroundColor }, to: self.indicatorImageView.rx.tintColor)
//            .disposed(by: self.disposeBag)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
//        self.indicatorImageView.right = self.contentView.width - 15
//    }
//
//    func bind(reactor: SettingItem) {
//        super.bind(item: reactor)
//        reactor.state.map{ $0.title }
//            .bind(to: self.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//    }
    
}

