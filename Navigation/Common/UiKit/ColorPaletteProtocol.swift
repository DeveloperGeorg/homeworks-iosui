import UIKit

protocol ColorPaletteProtocol {
    func getAccent() -> UIColor

    func getMainBackground() -> UIColor

    func getSecondaryBackground() -> UIColor

    func getBackgroundActionButtonAnabled() -> UIColor
    
    func getBackgroundActionButtonDisabled() -> UIColor
    
    func getTextActionButton() -> UIColor
    
    func getMainText() -> UIColor
    
    func getSecondaryText() -> UIColor
}
