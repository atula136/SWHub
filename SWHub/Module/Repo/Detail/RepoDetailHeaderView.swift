//
//  RepoDetailHeaderView.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import SWFrame

class RepoDetailHeaderView: SupplementaryView, ReactorKit.View {

    lazy var titleLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.font = .normal(16)
        label.qmui_lineHeight = flat(label.font.lineHeight + 2)
        label.sizeToFit()
        return label
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        return imageView
    }()

    lazy var starButton: Button = {
        let button = Button(type: .custom)
        button.setImage(R.image.detail_btn_unstarred()?.template, for: .normal)
        button.setImage(R.image.detail_btn_starred()?.template, for: .selected)
        button.sizeToFit()
        button.size = CGSize(width: metric(30), height: metric(30))
        button.borderWidth = 1
        button.cornerRadius = button.size.width / 2.f
        return button
    }()

    lazy var watchButton: Button = {
        let button = Button(type: .custom)
        button.cornerRadius = 4
        button.titleLabel?.numberOfLines = 2
        return button
    }()

    lazy var starCountButton: Button = {
        let button = Button(type: .custom)
        button.cornerRadius = 4
        button.titleLabel?.numberOfLines = 2
        return button
    }()

    lazy var forkButton: Button = {
        let button = Button(type: .custom)
        button.cornerRadius = 4
        button.titleLabel?.numberOfLines = 2
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.avatarImageView.width = metric(90)
        self.avatarImageView.height = self.avatarImageView.width
        self.avatarImageView.cornerRadius = self.avatarImageView.width / 2.f
        self.addSubview(self.avatarImageView)

        self.addSubview(self.starButton)
        self.addSubview(self.titleLabel)

        let width = flat((self.width - 20 * 2 - 10 * 2) / 3.f)
        let height = flat(self.height - self.avatarImageView.bottom - 10 - 20)
        self.watchButton.size = CGSize(width: width, height: height)
        self.starCountButton.size = self.watchButton.size
        self.forkButton.size = self.watchButton.size
        self.addSubview(self.watchButton)
        self.addSubview(self.starCountButton)
        self.addSubview(self.forkButton)

        themeService.rx
            .bind({ $0.textColor }, to: self.titleLabel.rx.textColor)
            .bind({ $0.backgroundColor }, to: [self.starButton.rx.borderColor, self.starButton.rx.tintColor])
            .bind({ $0.foregroundColor }, to: [self.starButton.rx.backgroundColor, self.watchButton.rx.backgroundColor, self.starCountButton.rx.backgroundColor, self.forkButton.rx.backgroundColor])
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.avatarImageView.image = nil
        self.watchButton.setAttributedTitle(nil, for: .normal)
        self.starCountButton.setAttributedTitle(nil, for: .normal)
        self.forkButton.setAttributedTitle(nil, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.left = 20
        self.avatarImageView.top = 10

        self.starButton.right = self.avatarImageView.right + 0
        self.starButton.bottom = self.avatarImageView.bottom + 0

        self.titleLabel.sizeToFit()
        self.titleLabel.width = self.width - self.avatarImageView.right - 10 - 20
        self.titleLabel.center = CGPoint(x: self.avatarImageView.right + 10 + self.titleLabel.width / 2, y: self.avatarImageView.center.y)

        self.watchButton.left = 20
        self.watchButton.bottom = self.height - 10
        self.starCountButton.left = self.watchButton.right + 10
        self.starCountButton.bottom = self.watchButton.bottom
        self.forkButton.left = self.starCountButton.right + 10
        self.forkButton.bottom = self.watchButton.bottom
    }

    func bind(reactor: RepoDetailHeaderReactor) {
        super.bind(reactor: reactor)
        reactor.state.map { $0.avatar }
            .bind(to: self.avatarImageView.rx.image())
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.title }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.starred }
//            .distinctUntilChanged()
//            .bind(to: self.starButton.rx.isSelected)
//            .disposed(by: self.disposeBag)
        reactor.state.map { $0.follow }
            .bind(to: self.watchButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.star }
            .bind(to: self.starCountButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.fork }
            .bind(to: self.forkButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: RepoDetailHeaderView {

    var starred: Binder<Bool> {
        return Binder(self.base) { view, attr in
            view.starButton.isSelected = attr
        }
    }

    var star: ControlEvent<Bool> {
        let source = self.base.starButton.rx.tap.map { [weak view = self.base] _ -> Bool in
            guard let view = view else { return false }
            return !view.starButton.isSelected
        }
        return ControlEvent(events: source)
    }

    var watch: ControlEvent<Void> {
        return ControlEvent(events: self.base.watchButton.rx.tap)
    }

}
