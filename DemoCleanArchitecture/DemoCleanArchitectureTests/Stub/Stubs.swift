//
//  Stubs.swift
//  DemoCleanArchitectureTests
//
//  Created by KinWei on 2020/12/17.
//  Copyright © 2020 KinWei. All rights reserved.
//

import Foundation
@testable import DemoCleanArchitecture

struct Stubs {
    /// Test records of search querys response.
    let searchQuerys: [PhotosQuery] = [
        PhotosQuery(searchText: "Superman", perPage: 10, page: 1, createDate: Date()),
        PhotosQuery(searchText: "Cat", perPage: 20, page: 1, createDate: Date()),
        PhotosQuery(searchText: "Dog", perPage: 30, page: 1, createDate: Date())

    ]

    /// Test search local response.
    let photos: Photos = Photos(
        id: String(UUID().uuidString.prefix(10)),
        page: 1, pages: 1, perpage: 1,
        total: nil,
        photo: [
            Photo(id: "11111111", owner: "I'm 1111", secret: "aaaaaaa", server: "1111", farm: 1, title: "Doraemon 1111", ispublic: 1, isfriend: 0, isfamily: 0),
            Photo(id: "222222", owner: "I'm 2222", secret: "bbbbbbb", server: "2222", farm: 2, title: "Doraemon 2222", ispublic: 2, isfriend: 0, isfamily: 0),
            Photo(id: "33333333", owner: "I'm 3333", secret: "ccccccc", server: "3333", farm: 3, title: "Doraemon 3333", ispublic: 1, isfriend: 0, isfamily: 0),
            Photo(id: "44444444", owner: "I'm 4444", secret: "dddddddd", server: "4444", farm: 4, title: "Doraemon 4444", ispublic: 1, isfriend: 0, isfamily: 0),
            Photo(id: "55555555", owner: "I'm 5555", secret: "eeeeeeee", server: "5555", farm: 5, title: "Doraemon 5555", ispublic: 1, isfriend: 0, isfamily: 0)
        ]
    )

    let localFavorites: [Photo] = [
        Photo(id: "11111111", owner: "I'm 1111", secret: "aaaaaaa", server: "1111", farm: 1, title: "Favorited Doraemon 1111", ispublic: 1, isfriend: 0, isfamily: 0),
        Photo(id: "222222", owner: "I'm 2222", secret: "bbbbbbb", server: "2222", farm: 2, title: "Favorited Doraemon 2222", ispublic: 2, isfriend: 0, isfamily: 0)
    ]
}
