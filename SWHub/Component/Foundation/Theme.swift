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
    var bgColor: UIColor { get }
    var fgColor: UIColor { get }
    var dimColor: UIColor { get }
    var maskColor: UIColor { get }
    var tintColor: UIColor { get }
    var headColor: UIColor { get }
    var bodyColor: UIColor { get }
    var footColor: UIColor { get }
    var borderColor: UIColor { get }
    var indicatorColor: UIColor { get }
    var separatorColor: UIColor { get }
    var placeholderColor: UIColor { get }
    var highlightedColor: UIColor { get }
    var barStyle: UIBarStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var blurStyle: UIBlurEffect.Style { get }

    init(colorTheme: ColorTheme)
}

struct LightTheme: Theme {
    let bgColor = UIColor.Material.white
    let fgColor = UIColor.Material.black
    let dimColor = UIColor(hex: 0xF3F3F3)!
    let maskColor = UIColor(hex: 0xFAFAFA)!
    var tintColor = UIColor.Material.red
    let headColor = UIColor(hex: 0x333333)!
    let bodyColor = UIColor(hex: 0x666666)!
    let footColor = UIColor(hex: 0x999999)!
    let borderColor = UIColor(hex: 0xEEEEEE)!
    let indicatorColor = UIColor.orange
    let separatorColor = UIColor(hex: 0xDDDDDD)!
    let placeholderColor = UIColor.Material.grey
    let highlightedColor = UIColor.green
    let barStyle = UIBarStyle.default
    let statusBarStyle = UIStatusBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light
    let blurStyle = UIBlurEffect.Style.extraLight

    init(colorTheme: ColorTheme) {
        self.tintColor = colorTheme.color
    }
}

struct DarkTheme: Theme {
    let bgColor = UIColor(hex: 0x171a21)!
    let fgColor = UIColor.Material.black
    let dimColor = UIColor.Material.grey900
    let maskColor = UIColor.Material.grey900
    var tintColor = UIColor.Material.red
    let headColor = UIColor.Material.grey50
    let bodyColor = UIColor.Material.grey200
    let footColor = UIColor.Material.grey
    let borderColor = UIColor(hex: 0xEEEEEE)!
    let indicatorColor = UIColor.orange
    let separatorColor = UIColor(hex: 0xDDDDDD)!
    let placeholderColor = UIColor.Material.grey
    let highlightedColor = UIColor(hex: 0xffca03)!
    let barStyle = UIBarStyle.black
    let statusBarStyle = UIStatusBarStyle.lightContent
    let keyboardAppearance = UIKeyboardAppearance.dark
    let blurStyle = UIBlurEffect.Style.dark

    init(colorTheme: ColorTheme) {
        self.tintColor = colorTheme.color
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
