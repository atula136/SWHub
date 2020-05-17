//
//  RepoProfileCell.swift
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

class RepoProfileCell: CollectionCell, ReactorKit.View {

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

    func bind(reactor: RepoProfileItem) {
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
            .bind(to: self.langView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.issue }
            .bind(to: self.issueView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.request }
            .bind(to: self.requestView.rx.info)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let repo = item.model as? Repo else { return .zero }
        var height = 10.f
        height += Metric.avatarSize.height
        height += (UILabel.sizeThatFitsAttributedString(repo.detail, withConstraints: .init(width: screenWidth - Constant.Metric.margin * 2, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: 0).height + 5)
        height += Metric.countHeight
        height += Metric.infoHeight * 3
        return CGSize(width: width, height: flat(height))
    }

}

extension Reactive where Base: RepoProfileCell {
//    var blog: ControlEvent<URL> {
//        let source = self.base.blogInfoView.rx.tap.map { [weak cell = self.base] _ -> URL? in
//            cell?.blogInfoView.titleLabel.text?.url
//        }.filterNil()
//        return ControlEvent(events: source)
//    }
}
