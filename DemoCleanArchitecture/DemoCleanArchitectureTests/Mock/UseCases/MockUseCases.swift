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
