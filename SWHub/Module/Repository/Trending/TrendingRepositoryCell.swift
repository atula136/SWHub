//
//  TrendingRepositoryCell.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class TrendingRepositoryCell: RepositoryCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // self.badgeImageView.image = R.image.setting_badge_user()?.template
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
