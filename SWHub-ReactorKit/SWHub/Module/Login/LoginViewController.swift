//
//  LoginViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import ReactorKit
import HBDNavigationBar
import CGFloatLiteral
import Rswift
import URLNavigator
import SWFrame

class LoginViewController: ScrollViewController, ReactorKit.View {
    
//    lazy var bgImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = R.image.loginBg()
//        imageView.sizeToFit()
//        return imageView
//    }()
//
//
//    lazy var loginButton: Button = {
//        let button = Button(type: .custom)
//        button.titleLabel?.font = UIFont.normal(16)
//        button.setTitle(R.string.localizable.loginAuth(), for: .normal)
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var termLabel: Label = {
//        let label = Label()
//        label.textAlignment = .center
//        label.font = UIFont.normal(12)
//        label.text = R.string.localizable.loginTerm()
//        label.sizeToFit()
//        return label
//    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.logo()?.template
        imageView.sizeToFit()
        return imageView
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
//        self.hbd_barAlpha = 0
//        self.hbd_barShadowHidden = true
//        //self.navigationBar.transparet()
//
//        self.view.addSubview(self.bgImageView)
//        self.bgImageView.size = self.view.size
//        self.bgImageView.left = 0
//        self.bgImageView.top = 0
//
//        self.view.addSubview(self.logoImageView)
//        self.logoImageView.left = self.logoImageView.leftWhenCenter
//        self.logoImageView.top = flat(self.logoImageView.topWhenCenter * 0.4)
//
//        self.view.addSubview(self.loginButton)
//        self.loginButton.width = flat(self.view.width * 0.65)
//        self.loginButton.height = metric(50)
//        self.loginButton.left = self.loginButton.leftWhenCenter
//        self.loginButton.top = flat(self.loginButton.topWhenCenter * 1.6)
//
//        self.view.addSubview(self.termLabel)
//        self.termLabel.left = self.termLabel.leftWhenCenter
//        self.termLabel.top = self.loginButton.bottom + 10
//
//        themeService.rx
//            .bind({ $0.primaryColor }, to: self.loginButton.rx.backgroundColor)
//            .bind({ $0.textColor }, to: self.loginButton.rx.titleColor(for: .normal))
//            .bind({ $0.placeholderColor }, to: self.termLabel.rx.textColor)
//            .disposed(by: self.disposeBag)
        self.view.addSubview(self.logoImageView)
        
        themeService.rx
            .bind({ $0.textColor }, to: self.logoImageView.rx.tintColor)
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // self.loginButton.cornerRadius = self.loginButton.height / 2.f
        self.logoImageView.top = self.contentTop + metric(50)
        self.logoImageView.left = self.logoImageView.leftWhenCenter
    }
    
    func bind(reactor: LoginViewReactor) {
        super.bind(reactor: reactor)
        
//        // action
//        self.loginButton.rx.tap
//            .map { Reactor.Action.login }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//        // state
//        reactor.state.map { $0.isLoading }
//            .bind(to: self.rx.loading(active: true))
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.user }
//            .distinctUntilChanged()
//            .filter{ $0 != nil }
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                self.dismiss(animated: true, completion: nil)
//            }).disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
    }

}
