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
    var backgroundColor: UIColor { get }
    var foregroundColor: UIColor { get }
    var dimColor: UIColor { get }
    var maskColor: UIColor { get }
    var tintColor: UIColor { get }
    var titleColor: UIColor { get }
    var detailColor: UIColor { get }
    var statusColor: UIColor { get }
    var border1Color: UIColor { get }
    var border2Color: UIColor { get }
    var border3Color: UIColor { get }
    var special1Color: UIColor { get }
    var special2Color: UIColor { get }
    var special3Color: UIColor { get }
    var barStyle: UIBarStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var blurStyle: UIBlurEffect.Style { get }

    init(colorTheme: ColorTheme)
}

struct LightTheme: Theme {
    let backgroundColor = UIColor.Material.white
    let foregroundColor = UIColor.Material.black
    let dimColor = UIColor.Material.grey100
    let maskColor = UIColor.Material.grey900
    var tintColor = UIColor.Material.red
    let titleColor = UIColor.Material.grey900
    let detailColor = UIColor.Material.grey700
    let statusColor = UIColor.Material.grey500
    let border1Color = UIColor.Material.grey200
    let border2Color = UIColor.Material.grey300
    let border3Color = UIColor.Material.grey400
    let special1Color = UIColor.Material.deepOrange900
    let special2Color = UIColor.Material.white
    let special3Color = UIColor.Material.white
    let barStyle = UIBarStyle.default
    let statusBarStyle = UIStatusBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light
    let blurStyle = UIBlurEffect.Style.extraLight

    init(colorTheme: ColorTheme) {
        self.tintColor = colorTheme.color
    }
}

struct DarkTheme: Theme {
    let backgroundColor = UIColor(hex: 0x171a21)!
    let foregroundColor = UIColor.Material.black
    let dimColor = UIColor.Material.grey900
    let maskColor = UIColor.Material.grey900
    var tintColor = UIColor.Material.red
    let titleColor = UIColor.Material.grey100
    let detailColor = UIColor.Material.grey300
    let statusColor = UIColor.Material.grey500
    let border1Color = UIColor.Material.grey800
    let border2Color = UIColor.Material.grey700
    let border3Color = UIColor.Material.grey600
    let special1Color = UIColor.Material.white
    let special2Color = UIColor.Material.white
    let special3Color = UIColor.Material.white
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
