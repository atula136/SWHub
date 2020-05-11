//
//  UIColorExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

extension UIColor {

    static var bg: UIColor {
        return themeService.type.associatedObject.bgColor
    }

    static var fg: UIColor {
        return themeService.type.associatedObject.fgColor
    }

    static var primary: UIColor {
        return themeService.type.associatedObject.primaryColor
    }

    static var tint: UIColor {
        return themeService.type.associatedObject.tintColor
    }

    static var title: UIColor {
        return themeService.type.associatedObject.titleColor
    }

    static var detail: UIColor {
        return themeService.type.associatedObject.detailColor
    }

    static var status: UIColor {
        return themeService.type.associatedObject.statusColor
    }

    static var border: UIColor {
        return themeService.type.associatedObject.borderColor
    }

    static var indicator: UIColor {
        return themeService.type.associatedObject.indicatorColor
    }

    static var separator: UIColor {
        return themeService.type.associatedObject.separatorColor
    }

    static var placeholder: UIColor {
        return themeService.type.associatedObject.placeholderColor
    }

    static var highlighted: UIColor {
        return themeService.type.associatedObject.highlightedColor
    }

}
