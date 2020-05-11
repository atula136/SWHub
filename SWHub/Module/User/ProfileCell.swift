//
//  ProfileCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/11.
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

class ProfileCell: CollectionCell, ReactorKit.View {

    fileprivate struct Metric {
        static let avatarSize = CGSize(width: metric(60), height: metric(60))
        static let userHeight = metric(80)
        static let countHeight = metric(50)
    }

    lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bold(15)
        label.sizeToFit()
        return label
    }()

    lazy var descriptionLabel: Label = {
        let label = Label()
        label.font = .normal(14)
        label.sizeToFit()
        return label
    }()

    lazy var statusLabel: Label = {
        let label = Label()
        label.font = .normal(12)
        label.sizeToFit()
        return label
    }()

    lazy var reposButton: SWFrame.Button = {
        let button = SWFrame.Button(type: .custom)
        button.sizeToFit()
        return button
    }()

    lazy var followersButton: SWFrame.Button = {
        let button = SWFrame.Button(type: .custom)
        button.sizeToFit()
        return button
    }()

    lazy var followingButton: SWFrame.Button = {
        let button = SWFrame.Button(type: .custom)
        button.sizeToFit()
        return button
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.size = Metric.avatarSize
        imageView.cornerRadius = flat(imageView.width / 5.f)
        return imageView
    }()

    lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.indicator.template
        imageView.sizeToFit()
        return imageView
    }()

    lazy var userView: UIView = {
        let view = UIView()
        view.qmui_borderPosition = .bottom
        view.qmui_borderWidth = pixelOne
        view.sizeToFit()
        view.height = Metric.userHeight
        return view
    }()

    lazy var countView: UIView = {
        let view = UIView()
        view.qmui_borderPosition = .bottom
        view.qmui_borderWidth = pixelOne
        view.sizeToFit()
        view.height = Metric.countHeight
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.userView)
        self.userView.addSubview(self.avatarImageView)
        self.userView.addSubview(self.indicatorImageView)
        self.userView.addSubview(self.nameLabel)
        self.userView.addSubview(self.descriptionLabel)
        self.userView.addSubview(self.statusLabel)

        self.contentView.addSubview(self.countView)
        self.countView.addSubview(self.reposButton)
        self.countView.addSubview(self.followersButton)
        self.countView.addSubview(self.followingButton)

        themeService.rx
            .bind({ $0.titleColor }, to: self.nameLabel.rx.textColor)
            .bind({ $0.statusColor }, to: self.descriptionLabel.rx.textColor)
            .bind({ $0.detailColor }, to: self.statusLabel.rx.textColor)
            .bind({ $0.bgColor }, to: self.userView.rx.backgroundColor)
            .bind({ $0.tintColor }, to: self.indicatorImageView.rx.tintColor)
            .bind({ $0.borderColor }, to: self.userView.rx.qmui_borderColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // user
        self.userView.width = self.contentView.width
        self.userView.height = Metric.userHeight
        self.userView.left = 0
        self.userView.top = 0
        self.avatarImageView.left = 20
        self.avatarImageView.top = self.avatarImageView.topWhenCenter
        self.indicatorImageView.right = self.contentView.width - 20
        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.top = self.avatarImageView.top + 4
        self.descriptionLabel.sizeToFit()
        self.descriptionLabel.left = self.nameLabel.left
        self.descriptionLabel.extendToRight = self.indicatorImageView.left
        self.descriptionLabel.top = self.descriptionLabel.topWhenCenter
        self.statusLabel.sizeToFit()
        self.statusLabel.left = self.nameLabel.left
        self.statusLabel.bottom = self.avatarImageView.bottom - 4
        // count
        self.countView.width = self.contentView.width
        self.countView.left = 0
        self.countView.top = self.userView.bottom
        self.reposButton.width = self.countView.width / 3.f
        self.reposButton.height = self.countView.height
        self.reposButton.left = 0
        self.reposButton.top = 0
        self.followersButton.width = self.reposButton.width
        self.followersButton.height = self.reposButton.height
        self.followersButton.left = self.reposButton.right
        self.followersButton.top = 0
        self.followingButton.width = self.reposButton.width
        self.followingButton.height = self.reposButton.height
        self.followingButton.left = self.followersButton.right
        self.followingButton.top = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.statusLabel.text = nil
        self.avatarImageView.image = nil
    }

    func bind(reactor: ProfileItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.description }
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { R.string.localizable.userJoinMessage($0.createDate?.string(withFormat: "yyyy-MM-dd") ?? "") }
            .bind(to: self.statusLabel.rx.text)
            .disposed(by: self.disposeBag)
    //        reactor.state.map { $0.repo }
    //            .bind(to: self.repoButton.rx.attributedTitle(for: .normal))
    //            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

//
//    fileprivate struct Font {
//        static let repo = UIFont.bold(14)
//        static let description = UIFont.normal(14)
//    }
//
//
//
//

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
//        guard let item = item as? UserItem else { return .zero }
//        var height = 10 + Metric.avatarSize.height + 5 + Font.repo.lineHeight + 5
//        height += (item.currentState.description ?? "").height(thatFitsWidth: width - 20 - 20, font: Font.description)
//        height += 5
        return CGSize(width: width, height: metric(scale: 1))
    }

}
