import XCTest

final class ProfileCoordinatorTest: XCTestCase {
    func testStart() {
        // arrange
        let navigationController = UINavigationControllerSpy()
        let profileFactory = ProfileFactoryDummy()
        let userService = UserServiceDummy()
        let sut = ProfileCoordinator(
            navigationController: navigationController,
            loginFactory: LoginFactoryDummy(),
            profileFactory: profileFactory,
            userService: userService
        )
        
        // act
        sut.start()
        
        // assert
        XCTAssert(navigationController.lastShowedUiViewController is LogInViewControllerProtocol, "Expecting last view controller to be a LogInViewControllerProtocol implementation")
    }
    
    func testOpenProfile() {
        // arrange
        let navigationController = UINavigationControllerSpy()
        let profileFactory = ProfileFactoryDummy()
        let userService = UserServiceDummy()
        let sut = ProfileCoordinator(
            navigationController: navigationController,
            loginFactory: LoginFactoryDummy(),
            profileFactory: profileFactory,
            userService: userService
        )
        
        // act
        sut.openProfile(sender: nil)
        
        // assert
        XCTAssert(navigationController.lastShowedUiViewController is ProfileViewControllerProtocol, "Expecting last view controller to be a ProfileViewControllerProtocol implementation")
    }
    
    func testShowLoginError() throws {
        // arrange
        let navigationController = UINavigationControllerSpy()
        let profileFactory = ProfileFactoryDummy()
        let userService = UserServiceDummy()
        let sut = ProfileCoordinator(
            navigationController: navigationController,
            loginFactory: LoginFactoryDummy(),
            profileFactory: profileFactory,
            userService: userService
        )
        
        // act
        sut.showError(title: "Error", message: "Invalid login")
        
        // assert
        XCTAssert(navigationController.lastShowedUiViewController is UIAlertController, "Expecting last view controller to be a UIAlertController")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
