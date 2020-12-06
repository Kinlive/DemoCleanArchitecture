//
//  ResultViewModel.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct ResultViewModelActions {

}

struct ResultInput {
  let triggerFetch: Driver<Void>
  let photoSelected: PublishSubject<(Bool, IndexPath)>
}

typealias ResultCellSection = SectionModel<String, PhotosResultCellViewModel>
struct ResultOutput {
  let saved: Observable<IndexPath>
  let sectionOfCells: Observable<[ResultCellSection]>
  let removed: Observable<Void>
}

protocol ResultViewModel {
  func transform(input: ResultInput) -> ResultOutput
}

class DefaultResultViewModel: ResultViewModel {

  typealias PassValues = HasResultValues
  typealias ResultUseCase = HasSaveFavoriteUseCase & HasPhotosRemoteSearchUseCase & HasFetchFavoriteUseCase & HasRemoveFavoriteUseCase
  
  private let actions: ResultViewModelActions
  private let useCase: ResultUseCase
  private let passValues: PassValues

  init(useCase: ResultUseCase, actions: ResultViewModelActions, passValues: PassValues) {
    self.useCase = useCase
    self.actions = actions
    self.passValues = passValues
  }

  func transform(input: ResultInput) -> ResultOutput {

    let triggerShare = input.triggerFetch.asObservable().share()
    let cellButtonTapped = input.photoSelected.share()

    // search photos by query
    let search = triggerShare
      .flatMap { [weak self] in self?.searchRemoteCase() ?? .empty() }

    // fetch favorites photos of user selected
    let favor = Observable.of( // 沒有最新
        triggerShare,
        // 有可能因為點擊同時觸發 save 跟 fetchFavor，只是這邊比較早做所以提早刷新時，還尚未儲存到。
        cellButtonTapped.map { _ in }.delay(.seconds(1), scheduler: MainScheduler.instance)
      )
      .merge()
      .flatMap { [weak self] in self?.fetchFavoriteCase() ?? .empty() }

    // transfrom to sectionModel with search and favorite
    let cellViewModelSections = Observable.combineLatest(search, favor)
      .flatMapLatest { photos, favorites -> Observable<[PhotosResultCellViewModel]> in
        let viewModels = photos.photo.map { photo -> PhotosResultCellViewModel in
          let isFavor = favorites[self.passValues.resultQuery?.searchText ?? ""]?.contains(photo) ?? false
          return PhotosResultCellViewModel(photo: photo, wasFavorite: isFavor)
        }
        return Observable.just(viewModels)
      }
      .map { [ResultCellSection(model: "A section", items: $0)] }
      .share()

    let selectedCellViewModel = cellButtonTapped.withLatestFrom(cellViewModelSections)
    { photoSelected, sections -> ((Bool, IndexPath), PhotosResultCellViewModel) in
        let (_, indexPath) = photoSelected
        let cellViewModel = sections[indexPath.section].items[indexPath.row]
        return (photoSelected, cellViewModel)
     }
      .share()

    // handle add favorite action
    let saveCase = selectedCellViewModel
      .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
      .filter { (selected, cellViewModel) in selected.0 == false }
      .flatMap { [weak self] (selected, cellViewModel) -> Observable<IndexPath> in
        return (self?.saveFavoriteUseCase(of: cellViewModel.photo) ?? .empty())
          .map { _ in selected.1 }
      }
      .observeOn(MainScheduler.instance)

      let removeCase = selectedCellViewModel
        .filter { (selected, cellViewModel) in selected.0 }
        .flatMapLatest { [weak self] (selected, cellViewModel) in
          self?.useCase.removeFavoriteUseCase?
            .rx_remove(favorite: cellViewModel.photo)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background)) ?? .empty()
        }

    return ResultOutput(
      saved: saveCase,
      sectionOfCells: cellViewModelSections,
      removed: removeCase)
  }

  private func searchRemoteCase() -> Observable<Photos> {
    guard let query = self.passValues.resultQuery,
      let useCase = useCase.searchRemoteUseCase else {
        return .error(NSError(
          domain: "query or useCase not found",
          code: -990,
          userInfo: nil))
    }

    return useCase.rx_search(query: query)
  }

  private func fetchFavoriteCase() -> Observable<[String: [Photo]]> {
    return useCase.fetchFavoriteUseCase?.rx_fetchFavorite() ?? .empty()
  }

  private func saveFavoriteUseCase(of photo: Photo) -> Observable<Void> {

    guard let query = passValues.resultQuery,
      let useCase = useCase.saveFavoriteUseCase else { return .empty() }

    return useCase.rx_save(favorite: photo, of: query)
  }
}

// MARK: - Cell View Model
class PhotosResultCellViewModel {

  let photo: Photo
  var imageUrl: String?
  var wasFavorite: Bool

  init(photo: Photo, wasFavorite: Bool) {
    self.photo = photo
    imageUrl = "https://farm\(photo.farm).staticflickr.com/\(photo.server ?? "")/\(photo.id)_\(photo.secret ?? "").jpg"
    self.wasFavorite = wasFavorite
  }

}
