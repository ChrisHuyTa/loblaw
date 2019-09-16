//
//  ListingModel.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-12.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import Foundation

struct ListingWrapper: Codable {
    var kind: String
    var data: ListingModel
}

struct ListingModel: Codable {
    var after: String
    var before: String?
    var dist: Int
    var modhash: String
    var children: [ArticleWrapper]
}
