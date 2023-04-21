import UIKit

class LightColorPalette: ColorPaletteProtocol {
    func getAccent() -> UIColor
    {
        return UIColor(red: 246/255, green: 151/255, blue: 7/255, alpha: 1)
    }

    func getPrimaryBackground() -> UIColor
    {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }

    func getSecondaryBackground() -> UIColor
    {
        return UIColor(red: 245/255, green: 243/255, blue: 238/255, alpha: 1)
    }

    func getBackgroundActionButtonAnabled() -> UIColor
    {
        return UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1)
    }
    
    func getBackgroundActionButtonDisabled() -> UIColor {
        return UIColor(red: 170/255, green: 176/255, blue: 180/255, alpha: 1)
    }
    
    func getTextActionButton() -> UIColor
    {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    func getPrimaryText() -> UIColor
    {
        return UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1)
    }
    
    func getSecondaryText() -> UIColor
    {
        return UIColor(red: 126/255, green: 129/255, blue: 131/255, alpha: 1)
    }
}
