//
//  Theme.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import SwifterSwift
import SWFrame

let themeService = ThemeType.service(initial: .default)

public protocol Theme {
    var backgroundColor: UIColor { get }                            // 背景
    var foregroundColor: UIColor { get }                            // 前景
    var primaryColor: UIColor { get }                               // 主色
    var secondaryColor: UIColor { get }                             // 次色
    var textColor: UIColor { get }                                  // 文本
    var bodyColor: UIColor { get }                                  // 内容
    var headColor: UIColor { get }                                  // 头部
    var footColor: UIColor { get }                                  // 尾部
    var borderColor: UIColor { get }                                // 边框
    var indicatorColor: UIColor { get }                             // 指示器
    var separatorColor: UIColor { get }                             // 分隔条
    var placeholderColor: UIColor { get }                           // 占位符
    var highlightedColor: UIColor { get }                           // 高亮的
    var barStyle: UIBarStyle { get }                                // 栏样式
    var statusBarStyle: UIStatusBarStyle { get }                    // 状态栏
    var keyboardAppearance: UIKeyboardAppearance { get }            // 键盘表现
    var blurStyle: UIBlurEffect.Style { get }                       // 毛玻璃
}

public struct DefaultTheme: Theme {
    public let backgroundColor = UIColor.white
    public let foregroundColor = UIColor.black
    public let primaryColor = UIColor.Material.grey200
    public let secondaryColor = UIColor.Material.red
    public let textColor = UIColor.Material.grey900
    public let bodyColor = UIColor.Material.grey
    public let headColor = UIColor(0x666666)!
    public let footColor = UIColor.Material.grey
    public let borderColor = UIColor.Material.grey900
    public let indicatorColor = UIColor.orange
    public let separatorColor = UIColor(0xd1d1d1)!
    public let placeholderColor = UIColor.Material.grey
    public let highlightedColor = UIColor(0xffca03)!
    public let barStyle = UIBarStyle.default
    public let statusBarStyle = UIStatusBarStyle.default
    public let keyboardAppearance = UIKeyboardAppearance.light
    public let blurStyle = UIBlurEffect.Style.extraLight
}

public enum ThemeType: ThemeProvider {
    case `default`
    case light
    case dark
    
    public var associatedObject: Theme {
        return DefaultTheme()
    }
}

