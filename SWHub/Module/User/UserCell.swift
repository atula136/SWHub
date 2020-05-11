//
//  UserCell.swift
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

class UserCell: CollectionCell, ReactorKit.View {

    fileprivate struct Metric {
        static let avatarSize = CGSize(width: metric(25), height: metric(25))
    }

    fileprivate struct Font {
        static let repo = UIFont.bold(14)
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
        self.contentView.addSubview(self.descriptionLabel)

        themeService.rx
            .bind({ $0.borderColor }, to: self.rx.qmui_borderColor)
            .bind({ $0.detailColor }, to: self.descriptionLabel.rx.textColor)
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

        self.descriptionLabel.sizeToFit()
        self.descriptionLabel.left = self.avatarImageView.left
        self.descriptionLabel.extendToRight = self.contentView.width - 20
        self.descriptionLabel.top = self.repoButton.bottom + 5
        self.descriptionLabel.extendToBottom = self.contentView.height - 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.avatarImageView.image = nil
        self.repoButton.setAttributedTitle(nil, for: .normal)
    }

    func bind(reactor: UserItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.description }
            .bind(to: self.descriptionLabel.rx.text)
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
        guard let item = item as? UserItem else { return .zero }
        var height = 10 + Metric.avatarSize.height + 5 + Font.repo.lineHeight + 5
        height += (item.currentState.description ?? "").height(thatFitsWidth: width - 20 - 20, font: Font.description)
        height += 5
        return CGSize(width: width, height: flat(height))
    }

}
