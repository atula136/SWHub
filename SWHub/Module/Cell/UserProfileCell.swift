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
import BonMot
import TTTAttributedLabel
import Kingfisher
import SWFrame

class UserProfileCell: CollectionCell, ReactorKit.View {

    static let maxLines = 3

    fileprivate struct Metric {
        static let avatarSize = CGSize(metric(60))
        static let nameHeight = flat(Font.name.lineHeight + 4)
        static let timeHeight = flat(Font.time.lineHeight + 4)
        static let countHeight = metric(50)
        static let infoHeight = metric(44)
    }

    fileprivate struct Font {
        static let name = UIFont.bold(15)
        static let intro = UIFont.normal(13)
        static let time = UIFont.normal(12)
    }

    lazy var nameLabel: Label = {
        let label = Label()
        label.font = Font.name
        label.sizeToFit()
        return label
    }()

    lazy var introLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = Font.intro
        label.verticalAlignment = .center
        label.numberOfLines = UserProfileCell.maxLines
        label.sizeToFit()
        return label
    }()

    lazy var timeLabel: Label = {
        let label = Label()
        label.font = Font.time
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
        self.userView.addSubview(self.introLabel)
        self.userView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.countView)
        self.contentView.addSubview(self.companyView)
        self.contentView.addSubview(self.locationView)
        self.contentView.addSubview(self.emailView)
        self.contentView.addSubview(self.blogView)
        themeService.rx
            .bind({ $0.titleColor }, to: self.nameLabel.rx.textColor)
            .bind({ $0.contentColor }, to: self.introLabel.rx.textColor)
            .bind({ $0.datetimeColor }, to: self.timeLabel.rx.textColor)
            .bind({ $0.borderLightColor }, to: self.userView.rx.qmui_borderColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.timeLabel.text = nil
        self.introLabel.text = nil
        self.timeLabel.text = nil
        self.avatarImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // info
        let width = self.contentView.width
        let height = Metric.infoHeight
        var bottom = self.contentView.height
        if !self.blogView.isHidden {
            self.blogView.width = width
            self.blogView.height = height
            self.blogView.left = 0
            self.blogView.bottom = bottom
            bottom -= height
        }
        if !self.emailView.isHidden {
            self.emailView.width = width
            self.emailView.height = height
            self.emailView.left = 0
            self.emailView.bottom = bottom
            bottom -= height
        }
        if !self.locationView.isHidden {
            self.locationView.width = width
            self.locationView.height = height
            self.locationView.left = 0
            self.locationView.bottom = bottom
            bottom -= height
        }
        if !self.companyView.isHidden {
            self.companyView.width = width
            self.companyView.height = height
            self.companyView.left = 0
            self.companyView.bottom = bottom
            bottom -= height
        }
        // count
        self.countView.width = self.contentView.width
        self.countView.height = Metric.countHeight
        self.countView.left = 0
        self.countView.bottom = bottom
        // user
        self.userView.sizeToFit()
        self.userView.width = self.contentView.width
        self.userView.top = 0
        self.userView.left = 0
        self.userView.extendToBottom = self.countView.top
        self.avatarImageView.sizeToFit()
        self.avatarImageView.size = Metric.avatarSize
        self.avatarImageView.left = Constant.Metric.margin
        self.avatarImageView.top = self.avatarImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.height = Metric.nameHeight
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.extendToRight = self.userView.width - Constant.Metric.margin
        self.nameLabel.top = 5
        self.timeLabel.sizeToFit()
        self.timeLabel.height = Metric.timeHeight
        self.timeLabel.left = self.nameLabel.left
        self.timeLabel.bottom = self.userView.height - 5
        self.introLabel.sizeToFit()
        self.introLabel.left = self.nameLabel.left
        self.introLabel.extendToRight = self.nameLabel.extendToRight
        self.introLabel.top = self.nameLabel.bottom
        self.introLabel.extendToBottom = self.timeLabel.top
    }

    func bind(reactor: UserProfileItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.intro }
            .bind(to: self.introLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.time }
            .bind(to: self.timeLabel.rx.text)
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
        let limit = screenWidth - Constant.Metric.margin - Metric.avatarSize.width - 10 - Constant.Metric.margin
        let intro = (user.bio ?? "").styled(with: .font(Font.intro))
        var text = TTTAttributedLabel.sizeThatFitsAttributedString(intro, withConstraints: CGSize(width: limit, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: UserProfileCell.maxLines.uInt).height
        text += Metric.nameHeight
        text += Metric.timeHeight
        var height = flat(max(Metric.avatarSize.height, text) + 10)
        height += Metric.countHeight
        if !(user.companyInfo.title?.isEmpty ?? true) {
            height += Metric.infoHeight
        }
        if !(user.locationInfo.title?.isEmpty ?? true) {
            height += Metric.infoHeight
        }
        if !(user.emailInfo.title?.isEmpty ?? true) {
            height += Metric.infoHeight
        }
        if !(user.blogInfo.title?.isEmpty ?? true) {
            height += Metric.infoHeight
        }
        return CGSize(width: width, height: flat(height))
    }

}

extension Reactive where Base: UserProfileCell {

    var blog: ControlEvent<URL> {
        let source = self.base.blogView.rx.tap.map { [weak cell = self.base] _ -> URL? in
            guard let user = cell?.model as? User else { return nil}
            return user.blog?.url
        }.filterNil()
        return ControlEvent(events: source)
    }

    var list: ControlEvent<URL> {
        let source = self.base.countView.rx.tap.map { [weak cell = self.base] listType -> URL? in
            guard let user = cell?.model as? User,
                let username = user.username,
                var url = listType.url else { return nil}
            url.appendQueryParameters([
                Parameter.title: listType.title,
                Parameter.username: username,
                Parameter.listType: listType.rawValue.string
            ])
            return url
        }.filterNil()
        return ControlEvent(events: source)
    }

}
