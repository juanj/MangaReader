//
//  DictionaryView.swift
//  MangaReader
//
//  Created by Juan on 28/05/20.
//  Copyright © 2020 Bakura. All rights reserved.
//

import Foundation

protocol DictionaryViewDelegate: AnyObject {
    func lookup(_ dictionaryView: DictionaryView, text: String)
    func createSentence(_ dictionaryView: DictionaryView, term: SearchTermResult)
}

class DictionaryView: UIView {
    weak var delegate: DictionaryViewDelegate?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView()
    private var terms = [MergedTermSearchResult]()
    private var kanji = [FullKanjiResult]()
    private var termsViews = [DictionaryTermEntryView]()
    private var kanjiViews = [DictionaryKanjiEntryView]()
    private let maxHeight: CGFloat
    private var scrollViewHeightConstraint: NSLayoutConstraint!

    init(maxHeight: CGFloat) {
        self.maxHeight = maxHeight
        super.init(frame: .zero)
        configureScrollView()
        configureStackView()
        configureLoader()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addConstraintsTo(self, sides: .vertical)
        scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 0)
        scrollViewHeightConstraint.isActive = true
        scrollView.backgroundColor = .systemBackground
    }

    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        scrollView.addSubview(stackView)

        stackView.addConstraintsTo(scrollView, spacing: .init(left: 20, right: -20))
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true

        // Add this zero frame view so the stackview can calculate its frame even when ther are no entries.
        let zeroView = UIView(frame: .zero)
        stackView.addArrangedSubview(zeroView)
    }

    private func configureLoader() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func endLoading() {
        activityIndicator.stopAnimating()
    }

    func setEntries(terms: [MergedTermSearchResult], kanji: [FullKanjiResult]) {
        for termView in termsViews {
            stackView.removeArrangedSubview(termView)
            termView.removeFromSuperview()
        }
        termsViews.removeAll()
        self.terms = terms
        for term in terms {
            let entryView = DictionaryTermEntryView(result: term)
            entryView.delegate = self
            stackView.addArrangedSubview(entryView)
            termsViews.append(entryView)
        }

        for kanjiView in kanjiViews {
            stackView.removeArrangedSubview(kanjiView)
            kanjiView.removeFromSuperview()
        }
        kanjiViews.removeAll()
        self.kanji = kanji
        for kanji in kanji {
            let kanjiView = DictionaryKanjiEntryView(kanji: kanji)
            stackView.addArrangedSubview(kanjiView)
            kanjiViews.append(kanjiView)
        }

        stackView.layoutIfNeeded()
        scrollViewHeightConstraint?.constant = min(stackView.frame.height, maxHeight)
        layoutIfNeeded()
    }

    func scrollToTop() {
        scrollView.contentOffset = .zero
    }
}

extension DictionaryView: DictionaryTermEntryViewDelegate {
    func lookupText(_ dictionaryTermEntryView: DictionaryTermEntryView, text: String) {
        delegate?.lookup(self, text: text)
    }

    func createSentence(_ dictionaryTermEntryView: DictionaryTermEntryView, term: SearchTermResult) {
        delegate?.createSentence(self, term: term)
    }
}
