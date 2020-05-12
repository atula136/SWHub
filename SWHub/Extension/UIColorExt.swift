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

    static var dim: UIColor {
        return themeService.type.associatedObject.dimColor
    }

    static var mask: UIColor {
        return themeService.type.associatedObject.maskColor
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

    static var datetime: UIColor {
        return themeService.type.associatedObject.datetimeColor
    }

    static var border1: UIColor {
        return themeService.type.associatedObject.border1Color
    }

    static var border2: UIColor {
        return themeService.type.associatedObject.border2Color
    }

    static var border3: UIColor {
        return themeService.type.associatedObject.border3Color
    }

    static var special1: UIColor {
        return themeService.type.associatedObject.special1Color
    }

    static var special2: UIColor {
        return themeService.type.associatedObject.special2Color
    }

    static var special3: UIColor {
        return themeService.type.associatedObject.special3Color
    }

}
