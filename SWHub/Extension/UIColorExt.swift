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

    static var tint: UIColor {
        return themeService.type.associatedObject.tintColor
    }

    static var dim: UIColor {
        return themeService.type.associatedObject.dimColor
    }

    static var dimLight: UIColor {
        return themeService.type.associatedObject.dimLightColor
    }

    static var dimDark: UIColor {
        return themeService.type.associatedObject.dimDarkColor
    }

    static var text: UIColor {
        return themeService.type.associatedObject.textColor
    }

    static var textLight: UIColor {
        return themeService.type.associatedObject.textLightColor
    }

    static var textDark: UIColor {
        return themeService.type.associatedObject.textDarkColor
    }

    static var border: UIColor {
        return themeService.type.associatedObject.borderColor
    }

    static var borderLight: UIColor {
        return themeService.type.associatedObject.borderLightColor
    }

    static var borderDark: UIColor {
        return themeService.type.associatedObject.borderDarkColor
    }

}
