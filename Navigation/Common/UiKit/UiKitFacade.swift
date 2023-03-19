import UIKit

class UiKitFacade {
    private let colorPalette: ColorPaletteProtocol
    private let typography: TypographyProtocol

    init(colorPalette: LightColorPalette, typography: Typography) {
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
}
