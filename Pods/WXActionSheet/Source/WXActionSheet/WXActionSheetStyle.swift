//
//  WXActionSheetStyle.swift
//  WXActionSheet
//
//  Created by xu.shuifeng on 2020/6/19.
//

import Foundation


/// Style fotr WXActionSheet.
public enum WXActionSheetStyle {
    
    /// The system style. avaiable at iOS 13.0
    @available(iOS 13, *)
    case system
    /// The light style.
    case light
    /// The dark style.
    case dark
    /// The custom style.
    case custom(Appearance)
    
    var appearance: Appearance {
        switch self {
        case .system:
            if #available(iOS 12, *) {
                let userInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
                return userInterfaceStyle == .light ? WXActionSheetStyle.lightAppearance: WXActionSheetStyle.darkAppearance
            }
            return WXActionSheetStyle.lightAppearance
        case .light:
            return WXActionSheetStyle.lightAppearance
        case .dark:
            return WXActionSheetStyle.darkAppearance
        case .custom(let appearance):
            return appearance
        }
    }
    
    /// The default dark appearance for light style. You can change any property to create new light style.
    public static var lightAppearance: Appearance = {
        var appearance = Appearance()
        appearance.dimmingBackgroundColor = UIColor(white: 0, alpha: 0.5)
        appearance.containerBackgroundColor = .white
        appearance.titleColor = UIColor(white: 0, alpha: 0.5)
        appearance.buttonHeight = 56.0
        appearance.buttonNormalBackgroundColor = UIColor(white: 1, alpha: 1)
        appearance.buttonHighlightBackgroundColor = UIColor(white: 248.0/255, alpha: 1)
        appearance.buttonTitleColor = .black
        appearance.destructiveButtonTitleColor = .red
        appearance.separatorLineColor = UIColor(white: 0, alpha: 0.1)
        appearance.separatorColor = UIColor(white: 247.0/255, alpha: 1.0)
        appearance.enableBlurEffect = false
        return appearance
    }()
    
    
    /// The default dark appearance for dark style. You can change any property to create new dark style.
    public static var darkAppearance: Appearance = {
        var appearance = Appearance()
        appearance.dimmingBackgroundColor = UIColor(white: 0, alpha: 0.8)
        appearance.containerBackgroundColor = UIColor(white: 44.0/255.0, alpha: 1.0)
        appearance.titleColor = UIColor(white: 1, alpha: 0.5)
        appearance.buttonHeight = 56.0
        appearance.buttonNormalBackgroundColor = UIColor(white: 44.0/255, alpha: 1.0)
        appearance.buttonHighlightBackgroundColor = UIColor(white: 54.0/255, alpha: 1.0)
        appearance.buttonTitleColor = UIColor.white
        appearance.destructiveButtonTitleColor = .red
        appearance.separatorLineColor = UIColor(white: 1, alpha: 0.05)
        appearance.separatorColor = UIColor(white: 30.0/255, alpha: 1.0)
        appearance.enableBlurEffect = false
        appearance.effect = UIBlurEffect(style: .dark)
        return appearance
    }()
}

public extension WXActionSheetStyle {
    
    struct Appearance {
        
        /// The background color of dimming background view.
        public var dimmingBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.5)
        
        /// The background color for the container view.
        public var containerBackgroundColor: UIColor = .white
        
        /// The text color for the title.
        public var titleColor: UIColor = UIColor(white: 0, alpha: 0.5)
        
        /// The height of button. 56 by default.
        public var buttonHeight: CGFloat = 56.0
        
        /// The background color of button in normal state.
        public var buttonNormalBackgroundColor = UIColor(white: 1, alpha: 1)

        /// The background color of button in highlighted state.
        public var buttonHighlightBackgroundColor = UIColor(white: 248.0/255, alpha: 1)
        
        /// Title color for normal buttons, default to UIColor.black
        public var buttonTitleColor = UIColor.black
        
        /// Title color for destructive button, default to UIColor.red
        public var destructiveButtonTitleColor = UIColor.red
        
        /// The separator line color.
        public var separatorLineColor: UIColor = UIColor(white: 0, alpha: 0.05)
        
        /// The  background color for separator between CancelButton and other buttons.
        public var separatorColor: UIColor = UIColor(white: 242.0/255, alpha: 1.0)
        
        /// A Boolean value indicating whether enable blur effect.
        public var enableBlurEffect: Bool = false
        
        public var effect: UIVisualEffect = UIBlurEffect(style: .light)
        
        public init() { }
    }
}
