//
//  BaseCollectionItem.swift
//  SWFrame
//
//  Created by 杨建祥 on 2020/4/10.
//

import UIKit

open class BaseCollectionItem: ReactorType, WithModel {
    
    public var model: ModelType
    
    public required init(_ model: ModelType) {
        self.model = model
    }
    
}
