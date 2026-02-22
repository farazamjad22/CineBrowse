//
//  AppTheme.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

enum AppTheme {
    // MARK: - Accent (same in both modes)

    static let accent = Color(red: 229/255, green: 9/255, blue: 20/255) // #E50914

    // MARK: - Backgrounds

    /// Dark: #0A0A0F (deep navy-black)  |  Light: #F5F0E8 (warm cream)
    static let background = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 10/255, green: 10/255, blue: 15/255, alpha: 1)
            : UIColor(red: 245/255, green: 240/255, blue: 232/255, alpha: 1)
    })

    /// Dark: #16161F  |  Light: #FFFFFF
    static let cardBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 22/255, green: 22/255, blue: 31/255, alpha: 1)
            : UIColor.white
    })

    /// Dark: #0A0A0F  |  Light: #EDE8DF (warm header)
    static let headerBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 10/255, green: 10/255, blue: 15/255, alpha: 1)
            : UIColor(red: 237/255, green: 232/255, blue: 223/255, alpha: 1)
    })

    // MARK: - Text

    /// Dark: #F0F0F0  |  Light: #1A1A1A
    static let primaryText = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            : UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
    })

    /// Dark: #8A8A9A (cool blue-gray)  |  Light: #7A7A7A
    static let secondaryText = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 138/255, green: 138/255, blue: 154/255, alpha: 1)
            : UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1)
    })

    // MARK: - Card Gradient (poster overlays)

    /// Dark: #1A0A2E (deep purple)  |  Light: black
    static let cardGradientStart = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 26/255, green: 10/255, blue: 46/255, alpha: 1)
            : UIColor.black
    })

    /// Dark: #0A0A0F (navy-black)  |  Light: black
    static let cardGradientEnd = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 10/255, green: 10/255, blue: 15/255, alpha: 1)
            : UIColor.black
    })

    // MARK: - Shadows

    /// Dark: deep black  |  Light: warm brown tint
    static let cardShadow = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            : UIColor(red: 160/255, green: 140/255, blue: 110/255, alpha: 0.35)
    })

    // MARK: - Placeholder

    static let placeholder = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 22/255, green: 22/255, blue: 31/255, alpha: 1)
            : UIColor(red: 237/255, green: 232/255, blue: 223/255, alpha: 1)
    })
}
