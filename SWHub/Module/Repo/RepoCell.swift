//
//  RepoCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/10.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Iconic
import SwifterSwift
import Kingfisher
import SWFrame

class RepoCell: CollectionCell, ReactorKit.View {

    fileprivate struct Metric {
        static let avatarSize = CGSize(width: metric(25), height: metric(25))
    }

    fileprivate struct Font {
        static let description = UIFont.normal(14)
    }

    lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bold(15)
        label.sizeToFit()
        label.height = flat(label.font.lineHeight)
        return label
    }()

    lazy var descriptionLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.font = Font.description
        label.sizeToFit()
        return label
    }()

    lazy var languageLabel: Label = {
        let label = Label()
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var starsLabel: Label = {
        let label = Label()
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var forksLabel: Label = {
        let label = Label()
        label.font = .normal(15)
        label.sizeToFit()
        return label
    }()

    lazy var statusLabel: Label = {
        let label = Label()
        label.font = .normal(10)
        label.sizeToFit()
        return label
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.size = Metric.avatarSize
        imageView.cornerRadius = flat(imageView.width / 2.f)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.qmui_borderPosition = .bottom
        self.qmui_borderWidth = pixelOne

        self.contentView.addSubview(self.avatarImageView)
        self.avatarImageView.top = 10
        self.avatarImageView.left = 20

        self.contentView.addSubview(self.nameLabel)
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.extendToRight = frame.size.width - 20
        self.nameLabel.centerY = self.avatarImageView.centerY

        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.languageLabel)
        self.contentView.addSubview(self.starsLabel)
        self.contentView.addSubview(self.forksLabel)
        self.contentView.addSubview(self.statusLabel)

        themeService.rx
            .bind({ $0.borderColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.headColor }, to: self.nameLabel.rx.textColor)
            .bind({ $0.footColor }, to: self.statusLabel.rx.textColor)
            .bind({ $0.bodyColor }, to: self.descriptionLabel.rx.textColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.descriptionLabel.sizeToFit()
        self.descriptionLabel.left = self.avatarImageView.left
        self.descriptionLabel.extendToRight = self.contentView.width - 20
        self.descriptionLabel.top = self.avatarImageView.bottom + 4
        self.descriptionLabel.extendToBottom = self.contentView.height - 40

        self.languageLabel.sizeToFit()
        self.languageLabel.bottom = self.contentView.height - 25
        self.languageLabel.left = self.avatarImageView.left

        self.starsLabel.sizeToFit()
        self.starsLabel.bottom = self.languageLabel.bottom
        self.starsLabel.left = flat(self.contentView.width / 2.f - 20)

        self.forksLabel.sizeToFit()
        self.forksLabel.bottom = self.languageLabel.bottom
        self.forksLabel.left = self.contentView.width - 70

        self.statusLabel.sizeToFit()
        self.statusLabel.top = self.forksLabel.bottom + 5
        self.statusLabel.left = self.avatarImageView.left
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.languageLabel.attributedText = nil
        self.starsLabel.attributedText = nil
        self.forksLabel.attributedText = nil
        self.statusLabel.text = nil
        self.avatarImageView.image = nil
    }

    func bind(reactor: RepoItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.description }
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.status }
            .bind(to: self.statusLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.language }
            .bind(to: self.languageLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.stars }
            .bind(to: self.starsLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.forks }
            .bind(to: self.forksLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let item = item as? RepoItem else { return .zero }
        var height = 10 + Metric.avatarSize.height + 4
        height += (item.currentState.description ?? "").height(thatFitsWidth: width - 20 - 20, font: Font.description)
        height += 65
        return CGSize(width: width, height: flat(height))
    }

//    lazy var titleLabel: Label = {
//        let label = Label()
//        label.font = .normal(14)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var subtitleLabel: Label = {
//        let label = Label()
//        label.font = .normal(12)
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
//        imageView.image = FontAwesomeIcon.bookIcon.image(ofSize: .s16, color: .foreground).template
//        imageView.sizeToFit()
//        imageView.borderColor = .white
//        imageView.borderWidth = 1
//        imageView.cornerRadius = imageView.width / 2.f
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
//        self.contentView.addSubview(self.subtitleLabel)
//        self.contentView.addSubview(self.detailLabel)
//
//        self.iconImageView.height = flat(frame.size.height * 0.8)
//        self.iconImageView.width = self.iconImageView.height
//        self.iconImageView.cornerRadius = self.iconImageView.width / 2.0
//        self.contentView.addSubview(self.iconImageView)
//
//        self.contentView.addSubview(self.badgeImageView)
//
//        self.contentView.addSubview(self.indicatorImageView)
//
//        themeService.rx
//            .bind({ $0.titleColor }, to: self.titleLabel.rx.textColor)
//            .bind({ $0.statusColor }, to: self.subtitleLabel.rx.textColor)
//            .bind({ $0.foregroundColor }, to: self.indicatorImageView.rx.tintColor)
//            .disposed(by: self.rx.disposeBag)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.titleLabel.text = nil
//        self.subtitleLabel.text = nil
//        self.detailLabel.attributedText = nil
//        self.iconImageView.image = nil
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
//        self.indicatorImageView.right = self.contentView.width - 15
//
//        self.iconImageView.left = 10
//        self.iconImageView.top = self.iconImageView.topWhenCenter
//        self.badgeImageView.left = self.iconImageView.left
//        self.badgeImageView.bottom = self.iconImageView.bottom
//
//        self.subtitleLabel.sizeToFit()
//        self.subtitleLabel.left = self.iconImageView.right + 8
//        self.subtitleLabel.top = self.subtitleLabel.topWhenCenter
//        self.subtitleLabel.width = self.indicatorImageView.left - self.subtitleLabel.left - 8 - 8
//
//        self.titleLabel.sizeToFit()
//        self.titleLabel.left = self.subtitleLabel.left
//        self.titleLabel.bottom = self.subtitleLabel.top
//
//        self.detailLabel.sizeToFit()
//        self.detailLabel.left = self.titleLabel.left
//        self.detailLabel.top = self.subtitleLabel.bottom + 4
//        self.detailLabel.extendToRight = self.indicatorImageView.left - 8
//    }
//
//    func bind(reactor: InfoItem) {
//        super.bind(item: reactor)
//        reactor.state.map { $0.title }
//            .bind(to: self.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.subtitle }
//            .bind(to: self.subtitleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.subtitle == nil }
//            .bind(to: self.subtitleLabel.rx.isHidden)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.detail }
//            .bind(to: self.detailLabel.rx.attributedText)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.detail == nil }
//            .bind(to: self.detailLabel.rx.isHidden)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.icon }
//            .bind(to: self.iconImageView.rx.image)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { _ in }
//            .bind(to: self.rx.setNeedsLayout)
//            .disposed(by: self.disposeBag)
//    }
//
//    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
//        return CGSize(width: width, height: metric(70))
//    }

}
