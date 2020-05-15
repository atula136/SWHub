//
//  RepoReadmeSourceCell.swift
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
import SwifterSwift
import Kingfisher
import SWFrame

class RepoReadmeSourceCell: CollectionCell, ReactorKit.View {

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.sizeToFit()
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.sizeToFit()
        self.textView.frame = self.contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.textView.attributedText = nil
    }

    func bind(reactor: RepoReadmeSourceItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.content }
            .bind(to: self.textView.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }

    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let readme = item.model as? Repo.Readme else { return .zero }
        let textView = UITextView()
        textView.attributedText = readme.highlightedCode
        let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: width, height: flat(size.height + 5))
    }

}
