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

class NormalCell: DefaultCollectionCell, ReactorKit.View {
    
    func bind(reactor: NormalItem) {
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
        reactor.state.map{ $0.accessory != .indicator && $0.accessory != .checkmark }
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
        reactor.state.map{ $0.accessory != .switcher(true) && $0.accessory != .switcher(false) }
            .bind(to: self.switcher.rx.isHidden)
            .disposed(by: self.disposeBag)
        reactor.state.map { state -> Bool in
            switch state.accessory {
            case let .switcher(isOn):
                return isOn
            default:
                return false
            }
        }.bind(to: self.switcher.rx.isOn).disposed(by: self.disposeBag)
        reactor.state.map{ _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
}
