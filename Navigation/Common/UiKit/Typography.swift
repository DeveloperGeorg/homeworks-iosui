import UIKit

class Typography: TypographyProtocol {
    
    func getPrimaryTitle() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    func getSecondaryTitle() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    func getTertiaryTitle() -> UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    func getQuaternaryTitle() -> UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    func getRegularText() -> UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    func getSmallText() -> UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
