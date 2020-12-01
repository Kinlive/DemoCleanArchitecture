//
//  SearchViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  func transform(input: Input) -> Output
}

// ViewModel Actions which tells to coordinator when to present another views.
struct SearchViewModelActions {

  let showResult: Action<PhotosQuery, Void>
}

struct SearchViewModelInput {

  let onTappedSearchButton = PublishSubject<Void>()

  let selectedRecord = PublishSubject<IndexPath>()

  let searchText = PublishSubject<String>()
  let perPage = PublishSubject<String>()
  let page = PublishSubject<String>()

  let triggerReload: Driver<Void>
  let clear: Driver<Void>
}

struct SearchViewModelOutput {
  let reload: Driver<[RecordsSection]>

}

protocol SearchViewModel {
  func convert(input: SearchViewModelInput) -> SearchViewModelOutput
}

typealias RecordsSection = SectionModel<String, PhotosQuery>
final class DefaultSearchViewModel: SearchViewModel {

  // MARK: - Use cases
  // Tells viewModel which use case needs.
  typealias SearchUseCases = HasPhotosLocalSearchUseCase & HasSearchRecordUseCase
  private let useCases: SearchUseCases

  // MARK: - Actions
  private let actions: SearchViewModelActions

  private let bag = DisposeBag()

  // MARK: - Private observables.
  private var searchRecord: Observable<[PhotosQuery]> {
    return useCases.searchRecordUseCase?.rx_searchRecord() ?? .empty()
  }

  private var sectionItems: Observable<[RecordsSection]> {
    return searchRecord
      .filter { $0.isEmpty == false }
      .enumerated()
      .map {
        [
          RecordsSection(model: "\($0 + 1)'s Section", items: $1 )
        ]
      }
  }

  // MARK: - Initialize.
  init(actions: SearchViewModelActions, useCases: SearchUseCases) {
    self.useCases = useCases
    self.actions = actions

  }

  // Implements convert Input to Output.
  func convert(input: SearchViewModelInput) -> SearchViewModelOutput {

    let allText = Observable.combineLatest(
      input.searchText,
      input.perPage,
      input.page
    )

    let canSearch = allText
      .map { text, perPage, page in !(text.isEmpty || perPage.isEmpty || page.isEmpty) }

    input.clear.asObservable()
      .subscribe(onNext: {
        input.searchText.onNext("")
        input.perPage.onNext("")
        input.page.onNext("")
      })
      .disposed(by: bag)

    // mapping user input to query for search.
    let searchQuery = input.onTappedSearchButton
      .withLatestFrom(canSearch)
      .filter { $0 }
      .withLatestFrom(allText)
      .map { search, perPage, page in
        PhotosQuery(
          searchText: search,
          perPage: Int(perPage) ?? 0,
          page: Int(page) ?? 0,
          createDate: Date()
        )
      }
      .share()

    let selectedQuery = input.selectedRecord
      .map { [weak self] indexPath -> Observable<PhotosQuery>? in
        return self?.sectionItems
          .map { sections in sections[indexPath.section] }
          .map { section in section.items[indexPath.row] }
      }
      .filter { $0 != nil }
      .flatMap { $0! }

    // show result
    Observable.merge(
      searchQuery,
      selectedQuery
    )
      .asDriver(onErrorJustReturn: .init(searchText: "", perPage: 1, page: 1, createDate: nil))
      .drive(actions.showResult.inputs)
      .disposed(by: bag)

    // when need to reload search list.
    let reload = input.triggerReload
      .asObservable()
      .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
      .map { [weak self] _ in self?.sectionItems ?? .empty() }
      .flatMap { $0 }
      .asDriver(onErrorJustReturn: [])

    return SearchViewModelOutput(reload: reload)
  }

}
