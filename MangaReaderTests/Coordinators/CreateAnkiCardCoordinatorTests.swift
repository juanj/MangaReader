//
//  CreateAnkiCardCoordinatorTests.swift
//  Kantan-MangaTests
//
//  Created by Juan on 20/02/21.
//

@testable import Kantan_Manga
import XCTest

class CreateAnkiCardCoordinatorTests: XCTestCase {
    func testStart_withNoPresentedView_presentsNavigable() {
        let mockNavigation = FakeNavigation()
        let createAnkiCardCoordinator = TestsFactories.createCreateAnkiCardCoordinator(navigable: mockNavigation)

        createAnkiCardCoordinator.start()

        XCTAssertNotNil(mockNavigation.presentedViewController as? Navigable)
    }

    func testStart_withNoPresentedView_setsRootViewControllerCreateAnkiViewController() {
        let presentedMockNavigation = FakeNavigation()
        let createAnkiCardCoordinator = TestsFactories.createTestableCreateAnkiCardCoordinator()

        createAnkiCardCoordinator.presentableNavigable = presentedMockNavigation
        createAnkiCardCoordinator.start()

        XCTAssertNotNil(presentedMockNavigation.viewControllers.first as? CreateAnkiCardViewController)
    }

    func testCancel_withDelegate_callsDidEnd() {
        let mockDelegate = FakeCreateAnkiCardCoordinatorDelegate()
        let createAnkiCardCoordinator = TestsFactories.createCreateAnkiCardCoordinator(delegate: mockDelegate)

        createAnkiCardCoordinator.start()
        createAnkiCardCoordinator.cancel(TestsFactories.createCreateAnkiCardViewController())

        XCTAssertTrue(mockDelegate.didEndCalled)
    }
}
