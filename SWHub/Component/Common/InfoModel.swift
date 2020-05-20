//
//  InfoModel.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/14.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import ObjectMapper
import SWFrame

struct InfoModel: ModelType {

    var indicated = true
    var title: String?
    var detail: String?
    var icon: UIImage?

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
    }

}
