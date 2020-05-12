//
//  SettingLoginCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import Iconic
import SwifterSwift
import SWFrame

class SettingLoginCell: CollectionCell, ReactorKit.View {

    lazy var titleLabel: Label = {
        let label = Label()
        label.font = .bold(16)
        label.text = R.string.localizable.clickToLogin()
        label.sizeToFit()
        return label
    }()

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FontAwesomeIcon.githubSignIcon.image(ofSize: .s64, color: .black).template
        imageView.sizeToFit()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 6
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.logoImageView)
        themeService.rx
            .bind({ $0.textDarkColor }, to: self.titleLabel.rx.textColor)
            .bind({ $0.tintColor }, to: self.logoImageView.rx.tintColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.logoImageView.height = flat(self.contentView.height * 0.5)
        self.logoImageView.width = self.logoImageView.height
        self.logoImageView.top = self.logoImageView.topWhenCenter
        self.logoImageView.right = self.contentView.width / 2.f - 8
        self.titleLabel.top = self.titleLabel.topWhenCenter
        self.titleLabel.left = self.logoImageView.right + 16
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func bind(reactor: SettingLoginItem) {
        super.bind(item: reactor)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        return CGSize(width: width, height: metric(100))
    }

}
