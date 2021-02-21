//
//  FakeCreateAnkiCardViewControllerDelegate.swift
//  Kantan-MangaTests
//
//  Created by Juan on 20/02/21.
//

import Foundation

@testable import Kantan_Manga

class FakeCreateAnkiCardViewControllerDelegate: CreateAnkiCardViewControllerDelegate {
    var cancelCalled = false
    var saveCalled = false
    var editImageCalled = false
    func cancel(_ createAnkiCardViewController: CreateAnkiCardViewController) {
        cancelCalled = true
    }

    func save(_ createAnkiCardViewController: CreateAnkiCardViewController) {
        saveCalled = true
    }

    func editImage(_ createAnkiCardViewController: CreateAnkiCardViewController) {
        editImageCalled = true
    }
}
