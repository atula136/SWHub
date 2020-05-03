//
//  SettingUserCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ReactorKit
import SwifterSwift
import Kingfisher
import SWFrame

class SettingUserCell: RepositoryCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgeImageView.image = R.image.setting_badge_user()?.template
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

