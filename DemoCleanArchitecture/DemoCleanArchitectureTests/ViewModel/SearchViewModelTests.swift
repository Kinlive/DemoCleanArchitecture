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
    private var useCase: DefaultSearchViewModel.SearchUseCases!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        useCase = UseCases(
            searchLocalUseCase: MockSearchLocalUseCase(),
            searchRecordUseCase: MockFetchRecordsUseCase()
        )

        //scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        testScheduler = nil

        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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

        viewModel = viewModel()
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

    func test_inputSearchTexts_to_triggerAction() throws {

        // arrange
        let bag = DisposeBag()
        let trigger = Observable.just(()).asDriver(onErrorJustReturn: ())
        let clean = Observable.just(()).asDriver(onErrorJustReturn: ())

        let observer = testScheduler.createObserver(PhotosQuery.self)

        let action: Action<PhotosQuery, Void> = Action { query in
            print("Here get query: \(query)")
            observer.onNext(query)
            return .empty()
        }

       viewModel = viewModel(with: action)

        let triggerSearch = testScheduler.createHotObservable([
            .next(100, "Cat"), .next(200, "Dog"), .next(300, "Doraemon")
        ])

        let triggerPerPage: TestableObservable<String> = testScheduler.createHotObservable([
            .next(100, "100")
        ])

        let triggerPage = testScheduler.createHotObservable([
            .next(100, "2"), .next(200, "5")
        ])

        let triggerTapped = testScheduler.createHotObservable([
            .next(100, ()), .next(200, ()), .next(300, ())
        ])

        let input = SearchViewModelInput(triggerReload: trigger, clear: clean)

        // bind to inputs
        triggerSearch.bind(to: input.searchText).disposed(by: bag)
        triggerPerPage.bind(to: input.perPage).disposed(by: bag)
        triggerPage.bind(to: input.page).disposed(by: bag)
        triggerTapped.bind(to: input.onTappedSearchButton).disposed(by: bag)

        let _ = viewModel.convert(input: input)

        // action
        testScheduler.start()

        let result = observer.events

        // assert
        XCTAssertEqual(result.count, 3) // tap 3 times with 3 query passed
        XCTAssertEqual(result[2].value.element?.searchText, "Doraemon")

    }

    private func viewModel(
        with action: Action<PhotosQuery, Void> = Action { _ in return .empty() })
    -> SearchViewModel {
        return DefaultSearchViewModel(actions: .init(showResult: action), useCases: useCase)
    }

}
