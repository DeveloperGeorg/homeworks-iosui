import UIKit

class UiKitFacade {
    /** @todo refactor:this is temporary solusion */
    static let shared = UiKitFacade(colorPalette: LightColorPalette(), typography: Typography())
    
    private let colorPalette: ColorPaletteProtocol
    private let typography: TypographyProtocol

    private init(colorPalette: ColorPaletteProtocol, typography: TypographyProtocol) {
        self.colorPalette = colorPalette
        self.typography = typography
    }
    
    func getAccentColor() -> UIColor {
        return self.colorPalette.getAccent()
    }

    func getPrimaryBackgroundColor() -> UIColor {
        return self.colorPalette.getPrimaryBackground()
    }

    func getSecondaryBackgroundColor() -> UIColor {
        return self.colorPalette.getSecondaryBackground()
    }

    func getBackgroundActionButtonAnabledColor() -> UIColor {
        return self.colorPalette.getBackgroundActionButtonAnabled()
    }
    
    func getBackgroundActionButtonDisabledColor() -> UIColor {
        return self.colorPalette.getBackgroundActionButtonDisabled()
    }
    
    func getTextActionButtonColor() -> UIColor {
        return self.colorPalette.getTextActionButton()
    }
    
    func getPrimaryTextColor() -> UIColor {
        return self.colorPalette.getPrimaryText()
    }
    
    func getSecondaryTextColor() -> UIColor {
        return self.colorPalette.getSecondaryText()
    }
    
    func getPrimaryTitleFont() -> UIFont {
        return typography.getPrimaryTitle()
    }
    
    func getSecondaryTitleFont() -> UIFont {
        return typography.getSecondaryTitle()
    }
    
    func getTertiaryTitleFont() -> UIFont {
        return typography.getTertiaryTitle()
    }
    
    func getQuaternaryTitleFont() -> UIFont {
        return typography.getQuaternaryTitle()
    }
    
    func getRegularTextFont() -> UIFont {
        return typography.getRegularText()
    }

    func getSmallTextFont() -> UIFont {
        return typography.getSmallText()
    }
    
    func getDefaultPaddingSize() -> Float {
        return typography.getDefaultPaddingSize()
    }
    
    func getConstraintContant(_ multiplier: Float) -> CGFloat {
        return CGFloat(multiplier * self.getDefaultPaddingSize())
    }
}
