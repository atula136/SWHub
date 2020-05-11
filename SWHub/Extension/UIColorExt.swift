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

    static var head: UIColor {
        return themeService.type.associatedObject.headColor
    }

    static var body: UIColor {
        return themeService.type.associatedObject.bodyColor
    }

    static var foot: UIColor {
        return themeService.type.associatedObject.footColor
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
