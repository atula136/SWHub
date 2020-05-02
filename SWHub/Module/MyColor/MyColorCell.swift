//
//  MyColorCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class MyColorCell: NormalCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 6
        self.iconImageView.height = flat(frame.size.height * 0.8)
        self.iconImageView.width = self.iconImageView.height
        self.iconImageView.cornerRadius = self.iconImageView.height / 2.f
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
