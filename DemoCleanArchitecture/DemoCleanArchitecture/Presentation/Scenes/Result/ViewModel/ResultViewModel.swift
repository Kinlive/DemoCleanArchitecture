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


    deinit {
        print("ResultViewModel deinit")
    }

  /*
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
        cellButtonTapped.map { _ in }//.delay(.seconds(1), scheduler: MainScheduler.instance)
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

    let selectedCellViewModel = cellButtonTapped
        .flatMapLatest { elements in
            Observable.combineLatest(Observable.just(elements), cellViewModelSections)
        }
        .map { elements, sections -> ((Bool, IndexPath), PhotosResultCellViewModel) in
            let (_, indexPath) = elements
            let cellViewModel = sections[indexPath.section].items[indexPath.row]
            return (elements, cellViewModel)
        }
        .share()

    // handle add favorite action
    let saveCaseSubject = PublishSubject<IndexPath>()
    selectedCellViewModel
      .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
      .filter { (selected, cellViewModel) in selected.0 == false }
      .flatMap { [weak self] (selected, cellViewModel) -> Observable<IndexPath> in
        return (self?.saveFavoriteUseCase(of: cellViewModel.photo) ?? .empty())
          .map { _ in selected.1 }
      }
      .observeOn(MainScheduler.instance)
      .bind(to: saveCaseSubject.asObserver())
      .disposed(by: bag)


      let removeCase = selectedCellViewModel
        .filter { (selected, cellViewModel) in selected.0 }
        .flatMapLatest { [weak self] (selected, cellViewModel) in
          self?.useCase.removeFavoriteUseCase?
            .rx_remove(favorite: cellViewModel.photo)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background)) ?? .empty()
        }

    return ResultOutput(
      saved: saveCaseSubject.asObservable(),
      sectionOfCells: cellViewModelSections,
      removed: removeCase)
  }
   */
    let bag = DisposeBag()

  func transform(input: ResultInput) -> ResultOutput {

    let onSavedTriggerReload = PublishSubject<Bool>()

    let reloadData: Observable<Bool> = Observable.of(
        input.triggerFetch.asObservable().map { true },
        onSavedTriggerReload.debug("\n\n======= On saved or remove trigger >> \n\n")
      )
      .merge()
      .share()

    let tappedShare = input.photoSelected.share()

    let favor = reloadData
      .flatMap { [weak self] _ in self?.fetchFavoriteCase() ?? .just([:]) }
      .debug("\n\n======= favorites ====== >>\n\n")

    let response = reloadData
      .flatMap { [weak self] _ in self?.searchRemoteCase() ?? .empty() }
      .debug("\n\n======= search remote ====== >> \n\n")
      

    let sectionOfCells = Observable.zip(response, favor)
      .flatMapLatest { response, favor -> Observable<[PhotosResultCellViewModel]> in
        guard let query = self.passValues.resultQuery else { return .just([]) }

        let viewModels = response.photo.map { photo -> PhotosResultCellViewModel in
          if let saved = favor[query.searchText] { // check had saved favorites photos
            return PhotosResultCellViewModel(photo: photo, wasFavorite: saved.contains(photo))
          } else {
            return PhotosResultCellViewModel(photo: photo, wasFavorite: false)
          }
        }

        return Observable.just(viewModels)
      }
      .enumerated()
      .map { (index, cellViewModels) in [ResultCellSection(model: "Section:\(index + 1)", items: cellViewModels)] }
      .share()
      //.debug("\n\n=======  On section reload >>\n\n ")

    let saved = tappedShare
      .filter { $0.0 == false }
      .withLatestFrom(sectionOfCells) { (elements, sections) -> ((Bool, IndexPath), Photo) in
        let (_, indexPath) = elements
        let photo = sections[indexPath.section].items[indexPath.row].photo
        return (elements, photo)
      } // 數值正確
      .flatMap { [weak self] (elements, photo) -> Observable<((Bool, IndexPath), Photo)> in
        let result = self?.saveFavoriteUseCase(of: photo)
          .catchError({ error -> Observable<Photo> in
            return .error(error)
          }) ?? .error(NSError(domain: "Save favorite failed", code: -991, userInfo: nil))
        // Notice: 如果是經由 API呼叫或其他task回傳的 Observable，務必直接將其作為回傳目標，後續再轉型。
        // 若此處直接回傳 (elelments, photo) 則會丟失進行中的元素傳遞。
        return result.map { photo in (elements, photo) }
      }
      .debug("=======  On saved with photo >>:\n\n")
      .map { (elements, photo) in elements.1 }
      .share()


    let removed = tappedShare
      .filter { $0.0 }
      .withLatestFrom(sectionOfCells) { (elements, sections) -> ((Bool, IndexPath), Photo) in
        let (_, indexPath) = elements
        let photo = sections[indexPath.section].items[indexPath.row].photo
        return (elements, photo)
      }
      .flatMap { [weak self] (elements, photo) in
        self?.useCase.removeFavoriteUseCase?
          .rx_remove(favorite: photo)
          .catchError({ error -> Observable<()> in
            return .error(error)
          }) ?? .error(NSError(domain: "Remove favorite failed", code: -992, userInfo: nil))
      }
      .debug("======= On favorite removed >> \n\n")
      .share()

    Observable.of(
        saved.map { _ in true },
        removed.map { _ in true }
      )
      .merge()
      .bind(to: onSavedTriggerReload)
      .disposed(by: bag)

    return ResultOutput(
      saved: saved,
      sectionOfCells: sectionOfCells,
      removed: removed
    )
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
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
  }

  private func fetchFavoriteCase() -> Observable<[String: [Photo]]> {
    return useCase.fetchFavoriteUseCase?.rx_fetchFavorite()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) ?? .just([:])
  }

  private func saveFavoriteUseCase(of photo: Photo) -> Observable<Photo> {

    guard let query = passValues.resultQuery,
      let useCase = useCase.saveFavoriteUseCase else { return .empty() }

    return useCase.rx_save(favorite: photo, of: query)
      .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
      .map { _ in photo }
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
