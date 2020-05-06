//
//  SettingSwitchCell.swift
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

class SettingSwitchCell: DefaultCell, ReactorKit.View {
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.sizeToFit()
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 6
        self.contentView.addSubview(self.switcher)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.switcher.right = self.contentView.width - 15
        self.switcher.top = self.switcher.topWhenCenter
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.switcher.isHidden = true
    }
    
    func bind(reactor: SettingSwitchItem) {
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
        reactor.state.map{ $0.accessory == .none }
            .bind(to: self.accessoryImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.accessory != .none }
            .bind(to: self.switcher.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map{ $0.switched }
            .distinctUntilChanged()
            .bind(to: self.switcher.rx.isOn)
            .disposed(by: self.disposeBag)
        reactor.state.map{ _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
}


extension Reactive where Base: SettingSwitchCell {
    
    var switched: ControlEvent<Bool> {
        let source = self.base.switcher.rx.isOn
        return ControlEvent(events: source)
    }
    
}
