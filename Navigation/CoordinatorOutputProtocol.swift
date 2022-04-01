import Foundation

typealias ComplitionBlock = (() -> Void)

protocol CoordinatorOutputProtocol: AnyObject {
    var finishFlow: ComplitionBlock? { get set }
    
}
