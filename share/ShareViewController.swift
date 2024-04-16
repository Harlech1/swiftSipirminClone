//
//  ShareViewController.swift
//  share
//
//  Created by Türker Kızılcık on 7.04.2024.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController, UITextViewDelegate {

    var inputTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 3
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = UIColor.secondarySystemGroupedBackground
        textView.text = ""
        return textView
    }()

    var outputTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 3
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = UIColor.secondarySystemGroupedBackground
        textView.text = ""
        return textView
    }()

    var lettersStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var lastTappedButtonLetter = ""

    var copyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Kopyala", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var placeholderLabel : UILabel = {
        let label = UILabel()
        label.text = "Çivirmik istidiğiniz mitni yiziniz..."
        label.textColor = UIColor.placeholderText
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var sharedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selam"

        view.backgroundColor = UIColor.systemGroupedBackground

        inputTextView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)

        setUpViews()
        createButtons()

        print("yo")

        handleSharedText()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("asdfg")
    }

    func handleSharedText() {
        print("fewata")
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem],
              let item = extensionItems.first,
              let itemProvider = item.attachments?.first else {
            print("asd")
            return
        }
        print("rwtreth")

        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypePlainText as String, options: nil) { [weak self] (item, error) in
                if let text = item as? String {
                    self?.sharedText = text
                    self?.placeholderLabel.text = ""
                    self?.placeholderLabel.isHidden = true
                    self?.inputTextView.text = text
                }
            }
        }
    }


    @objc func copyButtonTapped() {
        guard let textToSave = outputTextView.text else {
            print("TextView içinde kaydedilecek metin bulunamadı.")
            return
        }

        UIPasteboard.general.string = "\(textToSave) >> by sipirmin.com"
        print("Metin kopyalandı ve panoya kaydedildi.")
        showCopiedAlert()
    }

    func createButtons() {
        let titles = ["i","o","ö","u","ü"]
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor.systemRed
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            lettersStackView.addArrangedSubview(button)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        for btn in lettersStackView.subviews {
            btn.backgroundColor = UIColor.systemRed
        }
        sender.backgroundColor = UIColor.systemCyan
        lastTappedButtonLetter = sender.titleLabel?.text ?? ""

        outputTextView.text = replaceStringwithString(in: inputTextView, lastTappedButtonLetter)
    }

    func replaceStringwithString(in textView: UITextView, _ str: String) -> String {
        guard var text = textView.text else { return "" }

        text = text.replacingOccurrences(of: "a", with: str)
        text = text.replacingOccurrences(of: "e", with: str)
        text = text.replacingOccurrences(of: "ı", with: str)
        text = text.replacingOccurrences(of: "i", with: str)
        text = text.replacingOccurrences(of: "o", with: str)
        text = text.replacingOccurrences(of: "ö", with: str)
        text = text.replacingOccurrences(of: "u", with: str)
        text = text.replacingOccurrences(of: "ü", with: str)

        return text
    }

    func setUpViews() {
        view.addSubview(inputTextView)
        view.addSubview(outputTextView)
        view.addSubview(lettersStackView)
        view.addSubview(copyButton)
        view.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inputTextView.heightAnchor.constraint(equalToConstant: 200),

            lettersStackView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20),
            lettersStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lettersStackView.heightAnchor.constraint(equalToConstant: 40),

            outputTextView.topAnchor.constraint(equalTo: lettersStackView.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            outputTextView.heightAnchor.constraint(equalToConstant: 200),

            copyButton.topAnchor.constraint(equalTo: outputTextView.bottomAnchor, constant: 20),
            copyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            copyButton.widthAnchor.constraint(equalToConstant: 80),

            placeholderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            //placeholderLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    func showCopiedAlert() {
        let alert = UIAlertController(title: nil, message: "Kopyalandı", preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemCyan.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        outputTextView.text = replaceStringwithString(in: inputTextView, lastTappedButtonLetter)
    }
}
