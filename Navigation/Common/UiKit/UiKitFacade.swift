import UIKit

class UiKitFacade {
    private let colorPalette: ColorPaletteProtocol

    init(colorPalette: LightColorPalette) {
        self.colorPalette = colorPalette
    }
    
    func getAccentColor() -> UIColor {
        return self.colorPalette.getAccent()
    }

    func getMainBackgroundColor() -> UIColor {
        return self.colorPalette.getMainBackground()
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
    
    func getMainTextColor() -> UIColor {
        return self.colorPalette.getMainText()
    }
    
    func getSecondaryTextColor() -> UIColor {
        return self.colorPalette.getSecondaryText()
    }
}
