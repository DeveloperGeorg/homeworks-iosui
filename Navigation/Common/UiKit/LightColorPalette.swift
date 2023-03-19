import UIKit

class LightColorPalette: ColorPaletteProtocol {
    func getAccent() -> UIColor
    {
        return UIColor(red: 246, green: 151, blue: 7, alpha: 1)
    }

    func getPrimaryBackground() -> UIColor
    {
        return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    }

    func getSecondaryBackground() -> UIColor
    {
        return UIColor(red: 245, green: 243, blue: 238, alpha: 1)
    }

    func getBackgroundActionButtonAnabled() -> UIColor
    {
        return UIColor(red: 38, green: 50, blue: 56, alpha: 1)
    }
    
    func getBackgroundActionButtonDisabled() -> UIColor {
        return UIColor(red: 170, green: 176, blue: 180, alpha: 1)
    }
    
    func getTextActionButton() -> UIColor
    {
        return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    func getPrimaryText() -> UIColor
    {
        return UIColor(red: 38, green: 50, blue: 56, alpha: 1)
    }
    
    func getSecondaryText() -> UIColor
    {
        return UIColor(red: 126, green: 129, blue: 131, alpha: 1)
    }
}
