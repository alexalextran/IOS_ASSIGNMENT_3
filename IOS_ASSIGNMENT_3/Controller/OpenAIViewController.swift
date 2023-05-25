//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit

class OpenAIViewController: UIViewController, UITextFieldDelegate {
    private let viewModel = ViewModel()
    private let openAIManager = OpenAIManager()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let inputTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupConstraints()
            setupActions()
            viewModel.delegate = self
        }
    
        
        private func setupViews() {
            view.backgroundColor = .white
            
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            inputTextField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.axis = .vertical
            
            scrollView.addSubview(stackView)
            view.addSubview(scrollView)
            view.addSubview(inputTextField)
            view.addSubview(sendButton)
            
            inputTextField.borderStyle = .roundedRect // Add rounded border to the text field
            sendButton.setTitle("Send", for: .normal) // Set the title for the send button
        }
        
        private func setupConstraints() {
            let safeArea = view.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor),
                
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                inputTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
                inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
                inputTextField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
                
                sendButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
                sendButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
                sendButton.widthAnchor.constraint(equalToConstant: 80),
                sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor)
            ])
        }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        inputTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Resign the first responder status of the text field
        return true
    }
    
    @objc private func sendButtonTapped() {
        viewModel.sendMessage()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.currentInput = textField.text ?? ""
    }
}

extension OpenAIViewController: ViewModelDelegate {
    func reloadMessages() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for message in viewModel.messages.dropFirst().filter({ $0.role != .system }) {
            let messageLabel = UILabel()
            messageLabel.text = message.content
            messageLabel.textColor = message.role == .user ? .white : .black
            messageLabel.textAlignment = message.role == .user ? .right : .left
            messageLabel.numberOfLines = 0
            messageLabel.backgroundColor = message.role == .user ? .black : .gray.withAlphaComponent(0.1)
            messageLabel.layer.cornerRadius = 16
            messageLabel.clipsToBounds = true
            
            stackView.addArrangedSubview(messageLabel)
        }
    }
}

protocol ViewModelDelegate: AnyObject {
    func reloadMessages()
}


