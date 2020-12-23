//
//  ResultViewModelTests.swift
//  DemoCleanArchitectureTests
//
//  Created by KinWei on 2020/12/21.
//  Copyright © 2020 KinWei. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa

@testable import DemoCleanArchitecture
class ResultViewModelTests: XCTestCase {

    var viewModel: ResultViewModel!
    var testScheduler: TestScheduler!
    var useCase: DefaultResultViewModel.ResultUseCase!
    var bag: DisposeBag!

    var concurrentScheduler: ConcurrentDispatchQueueScheduler!

    private let passValue: DefaultResultViewModel.PassValues = AppPassValues(resultQuery: Stubs().searchQuerys.first)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testScheduler = TestScheduler(initialClock: 0)
        concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        useCase = UseCases(
            searchRemoteUseCase: MockSearchRemoteUseCase(),
            saveFavoriteUseCase: MockSaveFavoriteUseCase(),
            removeFavoriteUseCase: MockRemoveFavoriteUseCase(),
            fetchFavoriteUseCase: MockFetchFavoriteUseCase())

        viewModel = DefaultResultViewModel(
            useCase: useCase,
            actions: .init(),
            passValues: passValue)

        bag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        testScheduler = nil
        useCase = nil
        bag = DisposeBag()

    }

    func test_triggerToFetch_remotePhotos() throws {

      testScheduler = TestScheduler(initialClock: 0)
      // Arrange
      let observer = testScheduler.createObserver([ResultCellSection].self)

      let unuse_buttonTapped = PublishSubject<(Bool, IndexPath)>()

      let trigger = testScheduler.createColdObservable([
        .next(100, true),
        .next(200, true),
        .next(300, true),
        .next(400, true)
      ])
      .asDriver(onErrorJustReturn: false)
      .map { _ in }

      let input = ResultInput(
        triggerFetch: trigger,
        photoSelected: unuse_buttonTapped
      )

      let output = viewModel.transform(input: input)

      output.sectionOfCells
        .subscribe(observer)
        .disposed(by: bag)

      // Actoin
      testScheduler.start()

      // Assert
      let result = observer.events
      XCTAssertEqual(result.count, 1)
      XCTAssertEqual(result.first?.value.element?.first?.items.count, 5)
    }

  func test_triggerToFetch_remotePhotos_blocking() throws {

    // Arrange

    let buttonTapped = PublishSubject<(Bool, IndexPath)>()
    let triggerReload = PublishSubject<Void>()

    let input = ResultInput(
      triggerFetch: triggerReload.asDriver(onErrorJustReturn: ()),
      photoSelected: buttonTapped
    )

    let output = viewModel.transform(input: input)
    let sectionCells = output.sectionOfCells.subscribeOn(concurrentScheduler)

    // Actoin
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      triggerReload.onNext(())
    }

      let blocking = try sectionCells.toBlocking().first()

    // Assert
    XCTAssertEqual(blocking?.count, 1)
    XCTAssertEqual(blocking?.first?.items.count, 5)

    /* 連續使用兩個 toBlocking() 會導致test 無法跑完，原因未知。
    XCTAssertEqual(try sectionCells.toBlocking().first()?.count, 1)
    XCTAssertEqual(try sectionCells.toBlocking().first()?.first?.items.count, 5)
     */
  }

    func test_tappedButton_forSaveFavorite() throws {
        let bag = DisposeBag()


        let buttonTapped = PublishSubject<(Bool, IndexPath)>()

        let observer = testScheduler.createObserver(IndexPath.self)

        let fetchTrigger = testScheduler.createHotObservable([
            .next(90, ())
        ])
        .asDriver(onErrorJustReturn: ())

        let buttonTrigger = testScheduler.createHotObservable([
            .next(250, (false, IndexPath(row: 1, section: 0))),
            .next(350, (false, IndexPath(row: 0, section: 0)))
        ]).asObservable()

        buttonTrigger
            .bind(to: buttonTapped)
            .disposed(by: bag)

        let input = ResultInput(
            triggerFetch: fetchTrigger,
            photoSelected: buttonTapped)

        let output = viewModel.transform(input: input)

//        output.sectionOfCells.subscribe(onNext: { cells in
//            print(cells)
//        }).disposed(by: bag)

        output.saved.bind(to: observer).disposed(by: bag)

        testScheduler.start()

        let result = observer.events
        print("\n\nTest :\(#function) ========= ====== ")
        print(result)
        print("End with : \(#function) ================\n\n")
        //XCTAssertEqual(result[0], .next(250, IndexPath(row: 1, section: 0)))
        //XCTAssertEqual(result[1], .next(300, IndexPath(row: 0, section: 0)))

    }
}
