//
//  MangaCollection+CoreDataProperties.swift
//  MangaReader
//
//  Created by Juan on 4/02/20.
//  Copyright © 2020 Bakura. All rights reserved.
//

import CoreData

extension MangaCollection: MangaCollectionable {

  @nonobjc public class func createFetchRequest() -> NSFetchRequest<MangaCollection> {
        return NSFetchRequest<MangaCollection>(entityName: "MangaCollection")
    }

    var mangas: [Manga] {
        return (mangasInCollection?.array as? [Manga]) ?? []
    }

    @NSManaged public var name: String?
    @NSManaged private var mangasInCollection: NSOrderedSet?

}
