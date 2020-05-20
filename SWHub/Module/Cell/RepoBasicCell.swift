//
//  RepoBasicCell.swift
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

class RepoBasicCell: CollectionCell, ReactorKit.View {

    static let maxLines = 3

    fileprivate struct Metric {
        static let avatarSize = CGSize(width: metric(25), height: metric(25))
    }

    fileprivate struct Font {
        static let intro = UIFont.normal(14)
    }

    lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bold(15)
        label.sizeToFit()
        label.height = flat(label.font.lineHeight)
        return label
    }()

    lazy var introLabel: Label = {
        let label = Label()
        label.numberOfLines = RepoBasicCell.maxLines
        label.font = Font.intro
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

        self.contentView.addSubview(self.introLabel)
        self.contentView.addSubview(self.languageLabel)
        self.contentView.addSubview(self.starsLabel)
        self.contentView.addSubview(self.forksLabel)
        self.contentView.addSubview(self.statusLabel)

        themeService.rx
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.titleColor }, to: self.nameLabel.rx.textColor)
            .bind({ $0.datetimeColor }, to: self.statusLabel.rx.textColor)
            .bind({ $0.contentColor }, to: self.introLabel.rx.textColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.introLabel.sizeToFit()
        self.introLabel.left = self.avatarImageView.left
        self.introLabel.extendToRight = self.contentView.width - 20
        self.introLabel.top = self.avatarImageView.bottom
        self.introLabel.extendToBottom = self.contentView.height - 40

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
        self.introLabel.text = nil
        self.languageLabel.attributedText = nil
        self.starsLabel.attributedText = nil
        self.forksLabel.attributedText = nil
        self.statusLabel.text = nil
        self.avatarImageView.image = nil
    }

    func bind(reactor: RepoBasicItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.intro }
            .bind(to: self.introLabel.rx.text)
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
        guard let item = item as? RepoBasicItem else { return .zero }
        var height = 10 + Metric.avatarSize.height
        height += (item.currentState.intro ?? "").height(thatFitsWidth: width - 20 - 20, font: Font.intro, maxLines: RepoBasicCell.maxLines)
        height += 65
        return CGSize(width: width, height: flat(height))
    }

}
