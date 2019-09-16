//
//  Article.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-12.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import Foundation

struct ArticleWrapper: Codable {
    var kind: String
    var data: Article
}

struct Article: Codable {
    var title: String
    var thumbnailUrl: String
    var selftext: String
}
