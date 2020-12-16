//
//  FavoriteViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
extension Photo: IdentifiableType {
    var identity: String {
        return id
    }

    typealias Identity = String

}

typealias FavoriteSection = AnimatableSectionModel<String, Photo>
struct FavoriteViewModelActions {

}

struct FavoriteInput {
  let viewWillAppear: Observable<Bool>
  let tappedHeader = PublishSubject<(isExpanding: Bool, section: Int)>()
  let deleteFavorite: Observable<IndexPath>
}

struct FavoriteOutput {
  let sectionModels: Observable<[FavoriteSection]>
  let removeFavorite: Observable<Photo>

}

protocol FavoriteViewModel {
  var sectionHeaderTapped: PublishSubject<(Bool, Int)> { set get }
  var expandsIndex: [Int: Bool] { get set }
  func transform(input: FavoriteInput) -> FavoriteOutput
}

class DefaultFavoriteViewModel: FavoriteViewModel {

  typealias UseCases = HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase

  // MARK: - OUTPUT
  var tappedHeaderOn: ((Bool, [IndexPath]) -> Void)?
  var onFetchError: ((String) -> Void)?
  var onFavoritesPrepared: (() -> Void)?

  var sectionHeaderTapped: PublishSubject<(Bool, Int)> = PublishSubject()

  // MARK: - Properties
  private let useCases: UseCases
  private let actions: FavoriteViewModelActions

  private var fetchFavorites: [(title: String, photos: [Photo])] = []
  var expandsIndex: [Int : Bool] = [:]
  private let expandsIndexSubject = PublishSubject<[Int: Bool]>()

  init(actions: FavoriteViewModelActions, useCases: UseCases) {
    self.actions = actions
    self.useCases = useCases

    sectionHeaderTapped.subscribe(onNext: { [weak self] (isExpand, index) in
      self?.expandsIndex[index] = isExpand
      }).disposed(by: bag)
  }

  func transform(input: FavoriteInput) -> FavoriteOutput {

    //let favorFetch = input.viewWillAppear
    let favorFetch = Observable.merge(
      input.viewWillAppear.map { _ in },
        sectionHeaderTapped.map { _ in }
      )
      .flatMap { [weak self] _ in self?.fetchFavoriteUseCase() ?? .empty() }
      .map { [weak self] sections in
        sections.enumerated().map { index, element -> FavoriteSection in
          if self?.expandsIndex[index] ?? false { //? ???
            return element
          } else {
            return FavoriteSection(model: element.model, items: [])
          }
        }
      }
      .share()

    let removedCase = input.deleteFavorite
      .withLatestFrom(favorFetch) { indexPath, sections in
        sections[indexPath.section].items[indexPath.row]
      }
      .flatMap { [weak self] photo in
        self?.deleteFavoriteUseCase(deleted: photo)
          .map { photo } ?? .empty()
      }
      .do(afterNext: { _ in  })
      .share()

    return FavoriteOutput(
      sectionModels: favorFetch,
      removeFavorite: removedCase)
  }

  let bag = DisposeBag()

  private func fetchFavoriteUseCase() -> Observable<[FavoriteSection]> {
    guard let useCase = useCases.fetchFavoriteUseCase else { return .empty() }
    return useCase.rx_fetchFavorite()
      .map { values -> [FavoriteSection] in
        values
          .sorted(by: { $0.key > $1.key })
          .map { key, photos in FavoriteSection(model: key, items: photos) }
      }
      .do(onNext: { [weak self] sections in

        if sections.count == self?.expandsIndex.count {
            return
        }

        sections
          .enumerated()
          .forEach { [weak self] index, _ in
            self?.expandsIndex[index] = true
        }
      })
  }

  private func deleteFavoriteUseCase(deleted photo: Photo) -> Observable<Void> {
    guard let useCase = useCases.removeFavoriteUseCase else { return .empty() }
    return useCase.rx_remove(favorite: photo)
  }

}
