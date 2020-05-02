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

let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)
let themeService = ThemeType.service(initial: ThemeType.currentTheme())

protocol Theme {
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
    
    init(colorTheme: ColorTheme)
}

struct LightTheme: Theme {
    let backgroundColor = UIColor.Material.white
    var foregroundColor = UIColor.Material.red
    let primaryColor = UIColor.Material.grey200
    let secondaryColor = UIColor.Material.red
    let textColor = UIColor.Material.grey900
    let bodyColor = UIColor.Material.grey
    let headColor = UIColor(0x666666)!
    let footColor = UIColor.Material.grey
    let borderColor = UIColor.Material.grey900
    let indicatorColor = UIColor.orange
    let separatorColor = UIColor(0xd1d1d1)!
    let placeholderColor = UIColor.Material.grey
    let highlightedColor = UIColor.green
    let barStyle = UIBarStyle.default
    let statusBarStyle = UIStatusBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light
    let blurStyle = UIBlurEffect.Style.extraLight
    
    init(colorTheme: ColorTheme) {
        self.foregroundColor = colorTheme.color
    }
}

struct DarkTheme: Theme {
    let backgroundColor = UIColor.Material.grey800
    var foregroundColor = UIColor.Material.red
    let primaryColor = UIColor.Material.grey900
    let secondaryColor = UIColor.Material.red
    let textColor = UIColor.Material.grey50
    let bodyColor = UIColor.Material.grey
    let headColor = UIColor(0x666666)!
    let footColor = UIColor.Material.grey
    let borderColor = UIColor.Material.grey900
    let indicatorColor = UIColor.orange
    let separatorColor = UIColor(0xd1d1d1)!
    let placeholderColor = UIColor.Material.grey
    let highlightedColor = UIColor(0xffca03)!
    let barStyle = UIBarStyle.black
    let statusBarStyle = UIStatusBarStyle.lightContent
    let keyboardAppearance = UIKeyboardAppearance.dark
    let blurStyle = UIBlurEffect.Style.dark
    
    init(colorTheme: ColorTheme) {
        self.foregroundColor = colorTheme.color
    }
}

enum ColorTheme: Int {
    case red, pink, purple, deepPurple, indigo, blue, lightBlue, cyan, teal, green, lightGreen, lime, yellow, amber, orange, deepOrange, brown, gray, blueGray

    static let allValues = [red, pink, purple, deepPurple, indigo, blue, lightBlue, cyan, teal, green, lightGreen, lime, yellow, amber, orange, deepOrange, brown, gray, blueGray]

    var color: UIColor {
        switch self {
        case .red: return UIColor.Material.red
        case .pink: return UIColor.Material.pink
        case .purple: return UIColor.Material.purple
        case .deepPurple: return UIColor.Material.deepPurple
        case .indigo: return UIColor.Material.indigo
        case .blue: return UIColor.Material.blue
        case .lightBlue: return UIColor.Material.lightBlue
        case .cyan: return UIColor.Material.cyan
        case .teal: return UIColor.Material.teal
        case .green: return UIColor.Material.green
        case .lightGreen: return UIColor.Material.lightGreen
        case .lime: return UIColor.Material.lime
        case .yellow: return UIColor.Material.yellow
        case .amber: return UIColor.Material.amber
        case .orange: return UIColor.Material.orange
        case .deepOrange: return UIColor.Material.deepOrange
        case .brown: return UIColor.Material.brown
        case .gray: return UIColor.Material.grey
        case .blueGray: return UIColor.Material.blueGrey
        }
    }

    var title: String {
        switch self {
        case .red: return "Red"
        case .pink: return "Pink"
        case .purple: return "Purple"
        case .deepPurple: return "Deep Purple"
        case .indigo: return "Indigo"
        case .blue: return "Blue"
        case .lightBlue: return "Light Blue"
        case .cyan: return "Cyan"
        case .teal: return "Teal"
        case .green: return "Green"
        case .lightGreen: return "Light Green"
        case .lime: return "Lime"
        case .yellow: return "Yellow"
        case .amber: return "Amber"
        case .orange: return "Orange"
        case .deepOrange: return "Deep Orange"
        case .brown: return "Brown"
        case .gray: return "Gray"
        case .blueGray: return "Blue Gray"
        }
    }
}

enum ThemeType: ThemeProvider {
    case light(color: ColorTheme)
    case dark(color: ColorTheme)
    
    var associatedObject: Theme {
        switch self {
        case .light(let color): return LightTheme(colorTheme: color)
        case .dark(let color): return DarkTheme(colorTheme: color)
        }
    }
    
    var isDark: Bool {
        switch self {
        case .dark: return true
        default: return false
        }
    }
    
    func toggled() -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light(let color): theme = ThemeType.dark(color: color)
        case .dark(let color): theme = ThemeType.light(color: color)
        }
        theme.save()
        return theme
    }

    func withColor(color: ColorTheme) -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light: theme = ThemeType.light(color: color)
        case .dark: theme = ThemeType.dark(color: color)
        }
        theme.save()
        return theme
    }
    
}

extension ThemeType {
    
    struct Keys {
        static let isDark = "ThemeType.Keys.isDark"
        static let themeIndex = "ThemeType.Keys.themeIndex"
    }
    
    static func currentTheme() -> ThemeType {
        let isDark = UserDefaults.standard.bool(forKey: Keys.isDark)
        let colorTheme = self.colorTheme()
        let theme = isDark ? ThemeType.dark(color: colorTheme) : ThemeType.light(color: colorTheme)
        theme.save()
        return theme
    }
    
    static func colorTheme() -> ColorTheme {
        return ColorTheme(rawValue: UserDefaults.standard.integer(forKey: Keys.themeIndex)) ?? ColorTheme.red
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.isDark, forKey: Keys.isDark)
        switch self {
        case .light(let color): defaults.set(color.rawValue, forKey: Keys.themeIndex)
        case .dark(let color): defaults.set(color.rawValue, forKey: Keys.themeIndex)
        }
    }
    
}
