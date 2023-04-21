import UIKit

protocol TypographyProtocol {
    func getPrimaryTitle() -> UIFont
    func getSecondaryTitle() -> UIFont
    func getTertiaryTitle() -> UIFont
    func getQuaternaryTitle() -> UIFont
    func getRegularText() -> UIFont
    func getSmallText() -> UIFont
    func getDefaultPaddingSize() -> Float
}
