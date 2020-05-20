//
//  UserProfileCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/14.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Iconic
import RxOptional
import SwifterSwift
import Kingfisher
import SWFrame

class UserProfileCell: CollectionCell, ReactorKit.View {

    fileprivate struct Metric {
        static let avatarSize = CGSize.init(metric(25))
        static let countHeight = metric(50)
        static let infoHeight = metric(44)
    }

    lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bold(16)
        label.sizeToFit()
        return label
    }()

    lazy var detailLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.cornerRadius = flat(Metric.avatarSize.width / 5.f)
        return imageView
    }()

    lazy var userView: UIView = {
        let view = UIView()
        view.qmui_borderPosition = .bottom
        view.qmui_borderWidth = pixelOne
        view.sizeToFit()
        return view
    }()

    lazy var countView: CountView = {
        let view = CountView()
        view.sizeToFit()
        return view
    }()

    lazy var companyView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    lazy var locationView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    lazy var emailView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    lazy var blogView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.userView)
        self.userView.addSubview(self.avatarImageView)
        self.userView.addSubview(self.nameLabel)
        self.userView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.countView)
        self.contentView.addSubview(self.companyView)
        self.contentView.addSubview(self.locationView)
        self.contentView.addSubview(self.emailView)
        self.contentView.addSubview(self.blogView)
        themeService.rx
            .bind({ $0.titleColor }, to: self.nameLabel.rx.textColor)
            .bind({ $0.border1Color }, to: self.userView.rx.qmui_borderColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.detailLabel.attributedText = nil
        self.avatarImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // info
        let width = self.contentView.width
        let height = Metric.infoHeight
        self.blogView.width = width
        self.blogView.height = height
        self.blogView.left = 0
        self.blogView.bottom = self.contentView.height
        self.emailView.width = width
        self.emailView.height = height
        self.emailView.left = 0
        self.emailView.bottom = self.blogView.top
        self.locationView.width = width
        self.locationView.height = height
        self.locationView.left = 0
        self.locationView.bottom = self.emailView.top
        self.companyView.width = width
        self.companyView.height = height
        self.companyView.left = 0
        self.companyView.bottom = self.locationView.top
        // count
        self.countView.width = self.contentView.width
        self.countView.height = Metric.countHeight
        self.countView.left = 0
        self.countView.bottom = self.companyView.top
        // user
        self.userView.sizeToFit()
        self.userView.width = self.contentView.width
        self.userView.top = 0
        self.userView.left = 0
        self.userView.extendToBottom = self.countView.top
        self.avatarImageView.sizeToFit()
        self.avatarImageView.size = Metric.avatarSize
        self.avatarImageView.left = Constant.Metric.margin
        self.avatarImageView.top = 10
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.avatarImageView.right + Constant.Metric.padding
        self.nameLabel.extendToRight = self.userView.width - Constant.Metric.margin
        self.nameLabel.centerY = self.avatarImageView.centerY
        self.detailLabel.sizeToFit()
        self.detailLabel.left = self.avatarImageView.left
        self.detailLabel.extendToRight = self.nameLabel.right
        self.detailLabel.top = self.avatarImageView.bottom
        self.detailLabel.extendToBottom = self.userView.height
    }

    func bind(reactor: UserProfileItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.detail }
            .bind(to: self.detailLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.counts }
            .filterNil()
            .bind(to: self.countView.rx.counts)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.company }
            .bind(to: self.companyView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.location }
            .bind(to: self.locationView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.email }
            .bind(to: self.emailView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.blog }
            .bind(to: self.blogView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let user = item.model as? User else { return .zero }
        var height = 10.f
        height += Metric.avatarSize.height
        height += (UILabel.sizeThatFitsAttributedString(user.detail, withConstraints: .init(width: screenWidth - Constant.Metric.margin * 2, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0).height + 5)
        height += Metric.countHeight
        height += Metric.infoHeight * 4
        return CGSize(width: width, height: flat(height))
    }

}

extension Reactive where Base: UserProfileCell {
//    var blog: ControlEvent<URL> {
//        let source = self.base.blogInfoView.rx.tap.map { [weak cell = self.base] _ -> URL? in
//            cell?.blogInfoView.titleLabel.text?.url
//        }.filterNil()
//        return ControlEvent(events: source)
//    }
}
