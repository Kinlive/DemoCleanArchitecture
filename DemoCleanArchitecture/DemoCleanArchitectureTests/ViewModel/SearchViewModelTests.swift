//
//  SearchViewModelTexts.swift
//  DemoCleanArchitectureTests
//
//  Created by KinWei on 2020/12/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import Action
import RxBlocking

@testable import DemoCleanArchitecture

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var testScheduler: TestScheduler!

    // prepare something.
    private let voidAction: Action<PhotosQuery, Void> = Action { _ in return .empty() }
    private var useCase: DefaultSearchViewModel.SearchUseCases!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        useCase = UseCases(
            searchLocalUseCase: MockSearchLocalUseCase(),
            searchRecordUseCase: MockFetchRecordsUseCase()
        )

        viewModel = DefaultSearchViewModel(
            actions: .init(showResult: voidAction),
            useCases: useCase
        )

        //scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
     */

    func test_fetchRecords_correctly() throws {
        let bag = DisposeBag()

        let trigger = testScheduler.createHotObservable([
            Recorded.next(100, "1"),
            Recorded.next(200, "2"),
            Recorded.next(300, "3")
        ])
        .map { _ in }
        .asDriver(onErrorJustReturn: ())

        let unuseClear = Observable.just(()).asDriver(onErrorJustReturn: ())

        let output = viewModel.convert(input: .init(triggerReload: trigger, clear: unuseClear))

        output.reload.asObservable()
            .subscribe()
            .disposed(by: bag)

        testScheduler.start()

        let results = try? output.reload.toBlocking()
            .first()? // SectionModels
            .first?   // each
            .items    // PhotoQuerys

        // Assert result count equal
        XCTAssertEqual(results?.count, Stubs().searchQuerys.count)

        // Assert result contain equal
        XCTAssertEqual(
            results?.map { $0.searchText },
            Stubs().searchQuerys.map { $0.searchText }
        )
    }
}
