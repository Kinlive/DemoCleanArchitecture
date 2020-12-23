//
//  MockUseCases.swift
//  DemoCleanArchitectureTests
//
//  Created by KinWei on 2020/12/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
import RxSwift

@testable import DemoCleanArchitecture

class MockFetchRecordsUseCase: SearchRecordUseCase {

    func getSearchRecord(completion: @escaping ([PhotosQuery], Error?) -> Void) {
        /* now refactor to rxswift version, this method unused */
    }

    func rx_searchRecord() -> Observable<[PhotosQuery]> {
        return Observable.just(Stubs().searchQuerys)
    }

}

class MockSearchLocalUseCase: SearchLocalUseCase {
    func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) {
        completionHandler(Stubs().photos, nil)
    }
}


// Result viewModel tests
class MockSearchRemoteUseCase: SearchRemoteUseCase {
    func search(query: PhotosQuery, completionHandler: @escaping (Photos?, Error?) -> Void) {

    }

    func rx_search(query: PhotosQuery) -> Observable<Photos> {

        return Observable.just(Stubs().photos)
    }
}

class MockFetchFavoriteUseCase: FetchFavoriteUseCase {
    func fetchFavorite(completion: @escaping (Result<[String : [Photo]], Error>) -> Void) {

    }

    func rx_fetchFavorite() -> Observable<[String : [Photo]]> {

        return .just(["Test favorite" : Stubs().localFavorites])
    }
}

class MockRemoveFavoriteUseCase: RemoveFavoriteUseCase {
    func remove(favorite photo: Photo, completion: @escaping (Error?) -> Void) {

    }


    func rx_remove(favorite photo: Photo) -> Observable<Void> {

        print("Remove favorite photo: \(photo.id) success")
        return .empty()
    }
}

class MockSaveFavoriteUseCase: SaveFavoriteUseCase {

    func save(favorite photo: Photo, of request: PhotosQuery, completion: @escaping (Error?) -> Void) {

    }


    func rx_save(favorite photo: Photo, of request: PhotosQuery) -> Observable<Void> {
        print("Sava photo:\(photo.id) with request: \(request.searchText) success !")
        return .empty()
    }
}
