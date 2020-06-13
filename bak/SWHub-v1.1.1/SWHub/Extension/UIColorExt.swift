//
//  UIColorExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/28.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit

extension UIColor {

    static var background: UIColor {
        return themeService.type.associatedObject.backgroundColor
    }

    static var foreground: UIColor {
        return themeService.type.associatedObject.foregroundColor
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

    static var content: UIColor {
        return themeService.type.associatedObject.contentColor
    }

    static var datetime: UIColor {
        return themeService.type.associatedObject.datetimeColor
    }

    static var borderLight: UIColor {
        return themeService.type.associatedObject.borderLightColor
    }

    static var border: UIColor {
        return themeService.type.associatedObject.borderColor
    }

    static var borderDark: UIColor {
        return themeService.type.associatedObject.borderDarkColor
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
