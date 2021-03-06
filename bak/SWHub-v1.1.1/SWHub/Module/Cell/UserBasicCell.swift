//
//  UserBasicCell.swift
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
import TTTAttributedLabel
import Kingfisher
import SWFrame

class UserBasicCell: CollectionCell, ReactorKit.View {

    static let maxLines = 3

    fileprivate struct Metric {
        static let avatarSize = CGSize(width: metric(25), height: metric(25))
    }

    fileprivate struct Font {
        static let repo = UIFont.bold(14)
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
        label.numberOfLines = UserBasicCell.maxLines
        label.font = Font.intro
        label.sizeToFit()
        return label
    }()

    lazy var repoButton: SWFrame.Button = {
        let button = SWFrame.Button(type: .custom)
        button.titleLabel?.font = Font.repo
        button.sizeToFit()
        button.height = flat(Font.repo.lineHeight)
        return button
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

        self.contentView.addSubview(self.repoButton)
        self.contentView.addSubview(self.introLabel)

        themeService.rx
            .bind({ $0.borderLightColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.contentColor }, to: self.introLabel.rx.textColor)
            .bind({ $0.titleColor }, to: [self.nameLabel.rx.textColor, self.repoButton.rx.titleColor(for: .normal)])
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.repoButton.sizeToFit()
        self.repoButton.height = flat(Font.repo.lineHeight)
        self.repoButton.left = self.avatarImageView.left
        self.repoButton.top = self.avatarImageView.bottom + 5

        self.introLabel.sizeToFit()
        self.introLabel.left = self.avatarImageView.left
        self.introLabel.extendToRight = self.contentView.width - 20
        self.introLabel.top = self.repoButton.bottom + 5
        self.introLabel.extendToBottom = self.contentView.height - 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.introLabel.text = nil
        self.avatarImageView.image = nil
        self.repoButton.setAttributedTitle(nil, for: .normal)
    }

    func bind(reactor: UserBasicItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.intro }
            .bind(to: self.introLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.repo }
            .bind(to: self.repoButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let item = item as? UserBasicItem else { return .zero }
        let intro = (item.currentState.intro ?? "").styled(with: .font(Font.intro))
        var height = 10 + Metric.avatarSize.height + 5 + Font.repo.lineHeight + 5
        height += TTTAttributedLabel.sizeThatFitsAttributedString(intro, withConstraints: CGSize(width: width - 20 - 20, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: UserBasicCell.maxLines.uInt).height
        height += 5
        return CGSize(width: width, height: flat(height))
    }

}
