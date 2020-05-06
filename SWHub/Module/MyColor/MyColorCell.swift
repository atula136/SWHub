//
//  MyColorCell.swift
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
import SWFrame

class MyColorCell: DefaultCell, ReactorKit.View {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 6
        self.iconImageView.height = flat(frame.size.height * 0.8)
        self.iconImageView.width = self.iconImageView.height
        self.iconImageView.cornerRadius = self.iconImageView.height / 2.f
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MyColorItem) {
        super.bind(item: reactor)
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
        reactor.state.map{ $0.accessory == .none }
            .bind(to: self.accessoryImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { state -> UIImage? in
            switch state.accessory {
            case .indicator:
                return UIImage.indicator.template
            case .checkmark:
                return UIImage.check.template
            default:
                return nil
            }
        }.bind(to: self.accessoryImageView.rx.image).disposed(by: self.disposeBag)
        reactor.state.map{ _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
}
