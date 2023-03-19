import UIKit

protocol ColorPaletteProtocol {
    func getAccent() -> UIColor

    func getPrimaryBackground() -> UIColor

    func getSecondaryBackground() -> UIColor

    func getBackgroundActionButtonAnabled() -> UIColor
    
    func getBackgroundActionButtonDisabled() -> UIColor
    
    func getTextActionButton() -> UIColor
    
    func getPrimaryText() -> UIColor
    
    func getSecondaryText() -> UIColor
}
