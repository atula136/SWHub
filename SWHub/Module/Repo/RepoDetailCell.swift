//
//  RepoDetailCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
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

class RepoDetailCell: CollectionCell, ReactorKit.View {

    fileprivate struct Metric {
        static let avatarSize = CGSize.init(metric(25))
        static let countHeight = metric(50)
        static let infoHeight = metric(40)
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

    lazy var langView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    lazy var issueView: InfoView = {
        let view = InfoView()
        view.sizeToFit()
        return view
    }()

    lazy var requestView: InfoView = {
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
        self.contentView.addSubview(self.langView)
        self.contentView.addSubview(self.issueView)
        self.contentView.addSubview(self.requestView)
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
        self.requestView.sizeToFit()
        self.requestView.width = self.contentView.width
        self.requestView.height = Metric.infoHeight
        self.requestView.left = 0
        self.requestView.bottom = self.contentView.height
        self.issueView.sizeToFit()
        self.issueView.width = self.contentView.width
        self.issueView.height = Metric.infoHeight
        self.issueView.left = 0
        self.issueView.bottom = self.requestView.top
        self.langView.sizeToFit()
        self.langView.width = self.contentView.width
        self.langView.height = Metric.infoHeight
        self.langView.left = 0
        self.langView.bottom = self.issueView.top
        // count
        self.countView.width = self.contentView.width
        self.countView.height = Metric.countHeight
        self.countView.left = 0
        self.countView.bottom = self.langView.top
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

    func bind(reactor: RepoDetailItem) {
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
        reactor.state.map { $0.lang }
            .filterNil()
            .bind(to: self.langView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.issue }
            .filterNil()
            .bind(to: self.issueView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.request }
            .filterNil()
            .bind(to: self.requestView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let repo = item.model as? Repo else { return .zero }
        let label = Label()
        label.numberOfLines = 0
        label.attributedText = repo.detail()
        let size = label.sizeThatFits(.init(width: screenWidth - Constant.Metric.margin * 2, height: CGFloat.greatestFiniteMagnitude))
        var height = 10.f
        height += Metric.avatarSize.height
        height += (size.height + 5)
        height += Metric.countHeight
        height += Metric.infoHeight * 3
        return CGSize(width: width, height: flat(height))
    }

//
//    lazy var descriptionLabel: Label = {
//        let label = Label()
//        label.font = .normal(14)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var statusLabel: Label = {
//        let label = Label()
//        label.font = .normal(12)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var reposButton: SWFrame.Button = {
//        let button = SWFrame.Button(type: .custom)
//        button.titleLabel?.numberOfLines = 0
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var followersButton: SWFrame.Button = {
//        let button = SWFrame.Button(type: .custom)
//        button.titleLabel?.numberOfLines = 0
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var followingButton: SWFrame.Button = {
//        let button = SWFrame.Button(type: .custom)
//        button.titleLabel?.numberOfLines = 0
//        button.sizeToFit()
//        return button
//    }()
//
//
//    lazy var indicatorImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.indicator.template
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//
//    lazy var countView: UIView = {
//        let view = UIView()
//        view.qmui_borderPosition = .bottom
//        view.qmui_borderWidth = pixelOne
//        view.sizeToFit()
//        view.height = Metric.countHeight
//        return view
//    }()
//
//    lazy var companyInfoView: ProfileInfoView = {
//        let view = ProfileInfoView()
//        view.indicatorImageView.isHidden = true
//        view.iconImageView.image = FontAwesomeIcon.userIcon.image(ofSize: .init(20), color: .tint).template
//        view.sizeToFit()
//        view.height = Metric.itemHeight
//        return view
//    }()
//
//    lazy var locationInfoView: ProfileInfoView = {
//        let view = ProfileInfoView()
//        view.indicatorImageView.isHidden = true
//        view.iconImageView.image = FontAwesomeIcon.globeIcon.image(ofSize: .init(20), color: .tint).template
//        view.sizeToFit()
//        view.height = Metric.itemHeight
//        return view
//    }()
//
//    lazy var emailInfoView: ProfileInfoView = {
//        let view = ProfileInfoView()
//        view.indicatorImageView.isHidden = true
//        view.iconImageView.image = FontAwesomeIcon.inboxIcon.image(ofSize: .init(20), color: .tint).template
//        view.sizeToFit()
//        view.height = Metric.itemHeight
//        return view
//    }()
//
//    lazy var blogInfoView: ProfileInfoView = {
//        let view = ProfileInfoView()
//        view.iconImageView.image = FontAwesomeIcon._581Icon.image(ofSize: .init(20), color: .tint).template
//        view.sizeToFit()
//        view.height = Metric.itemHeight
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.contentView.addSubview(self.userView)
//        self.userView.addSubview(self.avatarImageView)
//        self.userView.addSubview(self.indicatorImageView)
//        self.userView.addSubview(self.nameLabel)
//        self.userView.addSubview(self.descriptionLabel)
//        self.userView.addSubview(self.statusLabel)
//
//        self.contentView.addSubview(self.countView)
//        self.countView.addSubview(self.reposButton)
//        self.countView.addSubview(self.followersButton)
//        self.countView.addSubview(self.followingButton)
//
//        self.contentView.addSubview(self.companyInfoView)
//        self.contentView.addSubview(self.locationInfoView)
//        self.contentView.addSubview(self.emailInfoView)
//        self.contentView.addSubview(self.blogInfoView)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // user
//        self.userView.width = self.contentView.width
//        self.userView.height = Metric.userHeight
//        self.userView.left = 0
//        self.userView.top = 0
//        self.avatarImageView.left = 20
//        self.avatarImageView.top = self.avatarImageView.topWhenCenter
//        self.indicatorImageView.right = self.contentView.width - 20
//        self.indicatorImageView.top = self.indicatorImageView.topWhenCenter
//        self.nameLabel.sizeToFit()
//        self.nameLabel.left = self.avatarImageView.right + 10
//        self.nameLabel.top = self.avatarImageView.top + 4
//        self.descriptionLabel.sizeToFit()
//        self.descriptionLabel.left = self.nameLabel.left
//        self.descriptionLabel.extendToRight = self.indicatorImageView.left
//        self.descriptionLabel.top = self.descriptionLabel.topWhenCenter
//        self.statusLabel.sizeToFit()
//        self.statusLabel.left = self.nameLabel.left
//        self.statusLabel.bottom = self.avatarImageView.bottom - 4
//        // count
//        self.countView.width = self.contentView.width
//        self.countView.left = 0
//        self.countView.top = self.userView.bottom
//        self.reposButton.width = self.countView.width / 3.f
//        self.reposButton.height = self.countView.height
//        self.reposButton.left = 0
//        self.reposButton.top = 0
//        self.followersButton.width = self.reposButton.width
//        self.followersButton.height = self.reposButton.height
//        self.followersButton.left = self.reposButton.right
//        self.followersButton.top = 0
//        self.followingButton.width = self.reposButton.width
//        self.followingButton.height = self.reposButton.height
//        self.followingButton.left = self.followersButton.right
//        self.followingButton.top = 0
//        // item
//        self.companyInfoView.width = self.contentView.width
//        self.companyInfoView.left = 0
//        self.companyInfoView.top = self.countView.bottom
//        self.locationInfoView.width = self.contentView.width
//        self.locationInfoView.left = 0
//        self.locationInfoView.top = self.companyInfoView.bottom
//        self.emailInfoView.width = self.contentView.width
//        self.emailInfoView.left = 0
//        self.emailInfoView.top = self.locationInfoView.bottom
//        self.blogInfoView.width = self.contentView.width
//        self.blogInfoView.left = 0
//        self.blogInfoView.top = self.emailInfoView.bottom
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.nameLabel.text = nil
//        self.descriptionLabel.text = nil
//        self.statusLabel.text = nil
//        self.companyInfoView.titleLabel.text = nil
//        self.locationInfoView.titleLabel.text = nil
//        self.emailInfoView.titleLabel.text = nil
//        self.blogInfoView.titleLabel.text = nil
//        self.reposButton.setAttributedTitle(nil, for: .normal)
//        self.followersButton.setAttributedTitle(nil, for: .normal)
//        self.followingButton.setAttributedTitle(nil, for: .normal)
//        self.avatarImageView.image = nil
//    }
//
//    func bind(reactor: ProfileItem) {
//        super.bind(item: reactor)
//        reactor.state.map { $0.name }
//            .bind(to: self.nameLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.description }
//            .bind(to: self.descriptionLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { R.string.localizable.userJoinMessage($0.createDate?.string(withFormat: "yyyy-MM-dd") ?? "") }
//            .bind(to: self.statusLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.company }
//            .bind(to: self.companyInfoView.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.location }
//            .bind(to: self.locationInfoView.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.email }
//            .bind(to: self.emailInfoView.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.blog }
//            .bind(to: self.blogInfoView.titleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.reposText }
//            .bind(to: self.reposButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.followersText }
//            .bind(to: self.followersButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.followingText }
//            .bind(to: self.followingButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.disposeBag)
//    }
//

}

extension Reactive where Base: RepoDetailCell {
//    var blog: ControlEvent<URL> {
//        let source = self.base.blogInfoView.rx.tap.map { [weak cell = self.base] _ -> URL? in
//            cell?.blogInfoView.titleLabel.text?.url
//        }.filterNil()
//        return ControlEvent(events: source)
//    }
}
