//
//  UserCell2.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/9.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import Iconic
import SWFrame

class UserCell2: InfoCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgeImageView.image = FontAwesomeIcon.userIcon.image(ofSize: .s16, color: .foreground).template
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
