//
//  CollectionCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class CollectionCell: BaseCollectionCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        themeService.rx
            .bind({ $0.bgColor }, to: self.contentView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
