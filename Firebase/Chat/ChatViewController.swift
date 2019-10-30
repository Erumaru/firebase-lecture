//
//  ChatViewController.swift
//  Firebase
//
//  Created by erumaru on 10/30/19.
//  Copyright © 2019 KBTU. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    // MARK: - Constants
    private struct Constants {
        static let messagePlaceholder = "Введите сообщение"
    }
    
    // MARK: - Variables
    var messages: [String] = []
    
    // MARK: - Outlets
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Отправить", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 300
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return view
    }()
    
    lazy var messageTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.placeholder = Constants.messagePlaceholder
        view.textContentType = .none
        view.keyboardType = .default
        view.returnKeyType = .done
        
        return view
    }()
    
    // MARK: - Actions
    @objc private func sendMessage() {
        guard let text = messageTextField.text else { return }
        
        ChatManager.shared.sendMessage(text)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        ChatManager.shared.delegate = self
        markup()
    }

    // MARK: - Markup
    private func markup() {
        view.backgroundColor = .white
        
        [tableView, messageTextField, sendMessageButton].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints() {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
        }
        
        messageTextField.snp.makeConstraints() {
            $0.bottom.equalTo(sendMessageButton.snp.top).offset(-8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(tableView.snp.bottom).offset(8)
            $0.height.equalTo(48)
        }
        
        sendMessageButton.snp.makeConstraints() {
            $0.height.equalTo(48)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
    }
}

extension ChatViewController: ChatDelegate {
    func updateChat(messages: [String]) {
        self.messages = messages
        self.tableView.reloadData()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
}
