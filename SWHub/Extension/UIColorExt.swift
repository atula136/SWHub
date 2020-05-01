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
    
    static var primary: UIColor {
        return themeService.type.associatedObject.primaryColor
    }
    
    static var secondary: UIColor {
        return themeService.type.associatedObject.secondaryColor
    }
    
    static var text: UIColor {
        return themeService.type.associatedObject.textColor
    }
    
    static var body: UIColor {
        return themeService.type.associatedObject.bodyColor
    }
    
    static var head: UIColor {
        return themeService.type.associatedObject.headColor
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

