//
//  SearchTermResult.swift
//  Kantan-Manga
//
//  Created by Juan on 17/01/21.
//

import Foundation
import GRDB

struct SearchTermResult: FetchableRecord {
    init(row: Row) {
        term = Term(row: row)
        dictionary = row["dictionary"]
    }

    var term: Term
    var dictionary: Dictionary
}
