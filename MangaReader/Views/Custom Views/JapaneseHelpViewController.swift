//
//  JapaneseHelpViewController.swift
//  MangaReader
//
//  Created by Juan on 29/05/20.
//  Copyright © 2020 Bakura. All rights reserved.
//

import UIKit

class JapaneseHelpViewController: UIViewController {
    var isDictionaryOpen: Bool {
        return dictView.frame.height > 0
    }
    var dictionaryHeight: CGFloat {
        return dictView.frame.height
    }

    private weak var delegate: JapaneseHelpViewControllerDelegate?

    private var dictView = DictionaryView(maxHeight: 500)
    private lazy var parsedInputView: ParsedInputField = ParsedInputField(delegate: self)

    init(delegate: JapaneseHelpViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        dictView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        parsedInputView.translatesAutoresizingMaskIntoConstraints = false
        dictView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(parsedInputView)
        view.addSubview(dictView)

        parsedInputView.addConstraintsTo(view, sides: [.horizontal, .top])
        dictView.addConstraintsTo(view, sides: [.horizontal, .bottom])
        dictView.topAnchor.constraint(equalTo: parsedInputView.bottomAnchor).isActive = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
        panGesture.delegate = self
        parsedInputView.addGestureRecognizer(panGesture)
    }

    private func lookupWord(_ word: JapaneseWord) {
        let dict = CompoundDictionary()
        dictView.startLoading()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try dict.connectToDataBase()
                let termResults = try dict.findTerm(word.rootForm)
                let kanjiResults = try dict.findKanji(word.text)
                DispatchQueue.main.async {
                    self.dictView.setEntries(terms: termResults, kanji: kanjiResults)
                    self.delegate?.didOpenDictionary(self)
                    self.dictView.scrollToTop()
                    self.dictView.endLoading()
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.dictView.endLoading()
                    print(error.localizedDescription)
                }
            }
        }
    }

    func setSentence(text: String) {
        parsedInputView.sentence = text
    }

    @objc func handlePan(pan: UIPanGestureRecognizer) {
        delegate?.handlePan(self, pan: pan)
    }
}

extension JapaneseHelpViewController: ParsedInputFieldDelegate {
    func willBeginEditing(_ parsedInputField: ParsedInputField) {
        dictView.setEntries(terms: [], kanji: [])
    }

    func didSelectWord(_ analyzeTextView: ParsedInputField, word: JapaneseWord) {
        lookupWord(word)
    }
}

extension JapaneseHelpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }

        // Only trigger when the gesture is vertical
        let velocity = panGestureRecognizer.velocity(in: inputView)
        return abs(velocity.y) > abs(velocity.x)
    }
}

extension JapaneseHelpViewController: DictionaryViewDelegate {
    func lookup(_ dictionaryView: DictionaryView, text: String) {
        let tokenizer = Tokenizer()
        let tokens = tokenizer.parse(text)
        let words = WordPaser.parse(tokens: tokens)
        if let first = words.first?.toJapaneseWord() {
            parsedInputView.clearSelection()
            lookupWord(first)
        }
    }

    func createSentence(_ dictionaryView: DictionaryView, term: SearchTermResult) {
        delegate?.createSentence(self, sentence: parsedInputView.sentence.replacingOccurrences(of: " ", with: ""), term: term)
    }
}

protocol JapaneseHelpViewControllerDelegate: AnyObject {
    func handlePan(_ japaneseHelpViewController: JapaneseHelpViewController, pan: UIPanGestureRecognizer)
    func didOpenDictionary(_ japaneseHelpViewController: JapaneseHelpViewController)
    func createSentence(_ japaneseHelpViewController: JapaneseHelpViewController, sentence: String, term: SearchTermResult)
}
