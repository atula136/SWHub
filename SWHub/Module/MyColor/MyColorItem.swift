//
//  MyColorItem.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import SWFrame

class MyColorItem: NormalItem {
    
    required init(_ model: ModelType) {
        super.init(model)
        guard let color = model as? MyColor else { return }
        self.initialState = State(
            icon: UIImage(color: color.id!.color, size: CGSize(width: 50, height: 50)),
            title: color.id?.title,
            accessory: color.checked() ? NormalItem.AccessoryType.checkmark : NormalItem.AccessoryType.none
        )
    }
    
}
