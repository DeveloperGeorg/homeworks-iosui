import XCTest

final class ProfileCoordinatorTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var navigationController = UINavigationControllerSpy()
        let profileFactory = ProfileFactoryDummy()
        let userService = UserServiceDummy()
        let sut = ProfileCoordinator(
            navigationController: navigationController,
            loginFactory: LoginFactoryDummy(),
            profileFactory: profileFactory,
            userService: userService
        )
        sut.start()
        XCTAssert(navigationController.lastShowedUiViewController is LogInViewControllerProtocol, "Expecting last view controller to be a LogInViewControllerProtocol implementation")
        sut.openProfile(sender: nil, loginInput: "loginInput")
        XCTAssert(navigationController.lastShowedUiViewController is ProfileViewControllerProtocol, "Expecting last view controller to be a ProfileViewControllerProtocol implementation")
        sut.showLoginError(title: "Error", message: "Invalid login")
        XCTAssert(navigationController.lastShowedUiViewController is UIAlertController, "Expecting last view controller to be a UIAlertController")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
