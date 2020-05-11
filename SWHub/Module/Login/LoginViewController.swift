//
//  LoginViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import RxOptional
import ReactorKit
import Iconic
import CGFloatLiteral
import Rswift
import URLNavigator
import SWFrame

class LoginViewController: ScrollViewController, ReactorKit.View {

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FontAwesomeIcon.githubSignIcon.image(ofSize: .s64, color: .black).template
        imageView.sizeToFit()
        return imageView
    }()

    lazy var accountField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.font = .normal(16)
        textField.placeholder = R.string.localizable.loginTitle()
        textField.borderWidth = 1
        textField.cornerRadius = 5
        textField.sizeToFit()
        return textField
    }()

    lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.font = .normal(16)
        textField.placeholder = R.string.localizable.loginPassword()
        textField.borderWidth = 1
        textField.cornerRadius = 5
        textField.sizeToFit()
        return textField
    }()

    lazy var loginButton: Button = {
        let button = Button(type: .custom)
        button.titleLabel?.font = .normal(18)
        button.imageForNormal = FontAwesomeIcon.githubIcon.image(ofSize: .s32, color: .white).template
        button.titleForNormal = R.string.localizable.loginTitle()
        button.centerTextAndImage(spacing: 10)
        button.cornerRadius = 5
        button.sizeToFit()
        return button
    }()

    init(_ navigator: NavigatorType, _ reactor: LoginViewReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.accountField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.loginButton)

        themeService.rx
            .bind({ $0.titleColor }, to: [self.logoImageView.rx.tintColor, self.accountField.rx.textColor, self.passwordField.rx.textColor])
            .bind({ $0.detailColor }, to: [self.accountField.rx.placeHolderColor, self.passwordField.rx.placeHolderColor])
            .bind({ $0.borderColor }, to: [self.accountField.rx.borderColor, self.passwordField.rx.borderColor])
            .bind({ $0.tintColor }, to: [self.accountField.rx.tintColor, self.passwordField.rx.tintColor])
            .bind({ $0.primaryColor }, to: self.loginButton.rx.titleColor(for: .normal))
            .bind({ UIImage(color: $0.tintColor, size: CGSize(width: 1, height: 1)) }, to: self.loginButton.rx.backgroundImage(for: .normal))
            .bind({ UIImage(color: $0.tintColor.withAlphaComponent(0.9), size: CGSize(width: 1, height: 1)) }, to: self.loginButton.rx.backgroundImage(for: .selected))
            .bind({ UIImage(color: $0.tintColor.withAlphaComponent(0.6), size: CGSize(width: 1, height: 1)) }, to: self.loginButton.rx.backgroundImage(for: .disabled))
            .bind({ $0.keyboardAppearance }, to: [self.accountField.rx.keyboardAppearance, self.passwordField.rx.keyboardAppearance])
            .disposed(by: self.rx.disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.logoImageView.top = self.contentTop + metric(50)
        self.logoImageView.left = self.logoImageView.leftWhenCenter

        self.accountField.width = flat(self.view.width * 0.8)
        self.accountField.height = metric(44)
        self.accountField.top = self.logoImageView.bottom + 8
        self.accountField.left = self.accountField.leftWhenCenter

        self.passwordField.width = self.accountField.width
        self.passwordField.height = self.accountField.height
        self.passwordField.top = self.accountField.bottom + 8
        self.passwordField.left = self.passwordField.leftWhenCenter

        self.loginButton.width = self.accountField.width
        self.loginButton.height = self.accountField.height
        self.loginButton.top = self.passwordField.bottom + 8
        self.loginButton.left = self.loginButton.leftWhenCenter
    }

    func bind(reactor: LoginViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.accountField.rx.text
            .map { Reactor.Action.account($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.passwordField.rx.text
            .map { Reactor.Action.password($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.loginButton.rx.tap
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.isLoading }
            .bind(to: self.rx.loading(active: true))
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.title }
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        Observable.combineLatest(reactor.state.map { $0.account }.replaceNilWith(""), reactor.state.map { $0.password }.replaceNilWith(""))
            .map { $0.isNotEmpty && $1.isNotEmpty }
            .distinctUntilChanged()
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}
