//
//  RepoReadmeCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import WebKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Iconic
import MarkdownView
import SwifterSwift
import Kingfisher
import SWFrame

class RepoReadmeCell: CollectionCell, ReactorKit.View {

//    lazy var webView: WKWebView = {
//        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
//        webView.sizeToFit()
//        return webView
//    }()

    lazy var mdView: MarkdownView = {
        let mdView = MarkdownView()
        return mdView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.mdView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.mdView.sizeToFit()
        self.mdView.frame = self.contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func bind(reactor: RepoReadmeItem) {
        super.bind(item: reactor)
//        reactor.state.map { $0.html }
//            .filterNil()
//            .bind(to: self.webView.rx.loadHTMLString)
//            .disposed(by: self.disposeBag)
//        reactor.state.map { $0.url }
//            .filterNil()
//            .bind(to: self.webView.rx.load)
//            .disposed(by: self.disposeBag)
        reactor.state.map { $0.markdown }.filterNil().subscribe(onNext: { [weak self] markdown in
            guard let `self` = self else { return }
            self.mdView.load(markdown: markdown)
        }).disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
//        guard let readme = item.model as? Repo.Readme else { return .zero }
//        let textView = UITextView()
//        textView.attributedText = readme.highlightedCode
//        let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: width, height: metric(400))
    }

}
