//
//  BodyDetailViewController.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 10/07/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class BodyDetailViewController: WHBaseViewController {
    var bottomViewInputConstraint: NSLayoutConstraint?
    let toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        return toolbar
    }()
    let labelWordFinded: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.backgroundColor = UIColor.clear
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()

    let textView: WHTextView = {
        let textView = WHTextView()
        if #available(iOS 10.0, *) {
            textView.textContentType = .none
            textView.autocapitalizationType = .sentences
        }
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let buttonPrevious: UIBarButtonItem = {
        return UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(previousStep(_:)))
    }()

    let buttonNext: UIBarButtonItem = {
        return UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextStep(_:)))
    }()

    static let kPadding: CGFloat = 10.0

    var searchController: UISearchController?
    var highlightedWords: [NSTextCheckingResult] = []
    var data: Data?
    var indexOfWord: Int = 0

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildView()
        NotificationCenter.default.addObserver(self, selector: #selector(BodyDetailViewController.handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BodyDetailViewController.handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        textView.font = UIFont(name: "Courier", size: 14)
        textView.dataDetectorTypes = UIDataDetectorTypes.link

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareContent(_:)))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        navigationItem.rightBarButtonItems = [searchButton, shareButton]

        buttonPrevious.isEnabled = false
        buttonNext.isEnabled = false
        addSearchController()
    }

    private func buildView() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        }
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.addSubview(labelWordFinded)
        labelWordFinded.topAnchor.constraint(equalTo:tView.topAnchor).isActive = true
        labelWordFinded.leftAnchor.constraint(equalTo:tView.leftAnchor, constant: 8.0).isActive = true
        labelWordFinded.rightAnchor.constraint(equalTo:tView.rightAnchor, constant: 8.0).isActive = true
        labelWordFinded.bottomAnchor.constraint(equalTo:tView.bottomAnchor).isActive = true

        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(customView: tView), buttonPrevious, buttonNext]

        self.view.addSubview(toolBar)
        toolBar.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        self.view.addSubview(textView)
        textView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true

        bottomViewInputConstraint = textView.bottomAnchor.constraint(equalTo:toolBar.safeAreaLayoutGuide.topAnchor)
        bottomViewInputConstraint?.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hud = showLoader(view: view)
        RequestModelBeautifier.body(data) { [weak self] (stringData) in
            let formattedJSON = stringData
            DispatchQueue.main.sync {
                self?.textView.text = formattedJSON
                self?.hideLoader(loaderView: hud)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //  MARK: - Search
    func addSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.returnKeyType = .done
        searchController?.searchBar.delegate = self
        if #available(iOS 9.1, *) {
            searchController?.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback
        }
        searchController?.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
        definesPresentationContext = true
    }

    @IBAction func previousStep(_ sender: UIBarButtonItem?) {
        indexOfWord -= 1
        if indexOfWord < 0 {
            indexOfWord = highlightedWords.count - 1
        }
        getCursor()
    }

    @IBAction func nextStep(_ sender: UIBarButtonItem?) {
        indexOfWord += 1
        if indexOfWord >= highlightedWords.count {
            indexOfWord = 0
        }
        getCursor()
    }

    func getCursor() {
        let value = highlightedWords[indexOfWord]
        if let range = textView.convertRange(range: value.range) {
            let rect = textView.firstRect(for: range)

            labelWordFinded.text = "\(indexOfWord + 1) of \(highlightedWords.count)"
            let focusRect = CGRect(origin: textView.contentOffset, size: textView.frame.size)
            if !focusRect.contains(rect) {
                textView.setContentOffset(CGPoint(x: 0, y: rect.origin.y - BodyDetailViewController.kPadding), animated: true)
            }
            cursorAnimation(with: value.range)
        }
    }

    func performSearch(text: String?) {
        highlightedWords.removeAll()
        highlightedWords = textView.highlights(text: text, with: Colors.UI.wordsInEvidence, font: UIFont(name: "Courier", size: 14)!, highlightedFont: UIFont(name: "Courier-Bold", size: 14)!)

        indexOfWord = 0

        if highlightedWords.count != 0 {
            getCursor()
            buttonPrevious.isEnabled = true
            buttonNext.isEnabled = true
        }
        else {
            buttonPrevious.isEnabled = false
            buttonNext.isEnabled = false
            labelWordFinded.text = "0 of 0"
        }
    }

    @objc func shareContent(_ sender: UIBarButtonItem){
        if let text = textView.text{
            let textShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc func showSearch() {
        searchController?.isActive = true
    }

    // MARK: - Keyboard

    @objc func handleKeyboardWillShow(_ sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }

        animationInputView(with: -keyboardSize.height, notification: sender)
    }

    @objc func handleKeyboardWillHide(_ sender: NSNotification) {
        animationInputView(with: 0.0, notification: sender)
    }

    func animationInputView(with height: CGFloat, notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber

        self.bottomViewInputConstraint?.constant = height

        UIView.animate(withDuration: duration?.doubleValue ?? 0.0, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue((curve?.intValue)!)), animations: {
            self.view.layoutIfNeeded()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BodyDetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty == false {
            performSearch(text: searchController.searchBar.text)
        }
        else {
            resetSearchText()
        }
    }
}

extension BodyDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension BodyDetailViewController {
    func resetSearchText() {
        let attributedString = NSMutableAttributedString(attributedString: self.textView.attributedText)
            attributedString.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: self.textView.attributedText.length))
            attributedString.addAttribute(.font, value: UIFont(name: "Courier", size: 14)!, range: NSRange(location: 0, length: self.textView.attributedText.length))

        self.textView.attributedText = attributedString
        self.labelWordFinded.text = "0 of 0"
        self.buttonPrevious.isEnabled = false
        self.buttonNext.isEnabled = false
    }

    func cursorAnimation(with range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: self.textView.attributedText)

        highlightedWords.forEach {
            attributedString.addAttribute(.backgroundColor, value: Colors.UI.wordsInEvidence, range: $0.range)
            attributedString.addAttribute(.font, value: UIFont(name: "Courier-Bold", size: 14)!, range: $0.range)
        }
        self.textView.attributedText = attributedString

        attributedString.addAttribute(.backgroundColor, value: Colors.UI.wordFocus, range: range)
        self.textView.attributedText = attributedString
    }
}
