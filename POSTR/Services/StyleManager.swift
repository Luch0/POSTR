//
//  StyleManager.swift
//  POSTR
//
//  Created by Lisa J on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation
import ChameleonFramework

typealias Style = StyleManager

//MARK: - StyleManager
final class StyleManager {
    
    // MARK: - StyleManager
    
    static func setUpTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryTheme(), withSecondaryColor: theme(), usingFontName: font(), andContentStyle: content())
    }
    
    // MARK: - Theme
    
    static func primaryTheme() -> UIColor {
        return FlatBlue()
    }
    
    static func theme() -> UIColor {
        return FlatBlue()
    }
    
    static func toolBarTheme() -> UIColor {
        return FlatBlue()
    }
    
    static func tintTheme() -> UIColor {
        return UIColor.clear
    }
    
    static func titleTextTheme() -> UIColor {
        return FlatWhite()
    }
    
    static func titleTheme() -> UIColor {
        return FlatCoffeeDark()
    }
    
    static func textTheme() -> UIColor {
        return FlatBlue()
    }
    
    static func backgroudTheme() -> UIColor {
        return FlatBlue()
    }
    
    static func positiveTheme() -> UIColor {
        return FlatBlue()
    }
    
    static func negativeTheme() -> UIColor {
        return FlatRed()
    }
    
    static func clearTheme() -> UIColor {
        return UIColor.clear
    }
    
    // MARK: - Content
    
    static func content() -> UIContentStyle {
        return UIContentStyle.contrast
    }
    
    // MARK: - Font
    static func font() -> String {
        return UIFont(name: FontType.Primary.fontName, size: FontType.Primary.fontSize)!.fontName
    }
}

//MARK: - FontType
enum FontType {
    case Primary
}

extension FontType {
    var fontName: String {
        switch self {
        case .Primary:
            return "HelveticaNeue"
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .Primary:
            return 16
        }
    }
}
