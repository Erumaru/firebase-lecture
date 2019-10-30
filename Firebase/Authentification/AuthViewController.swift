//
//  AuthViewController.swift
//  Firebase
//
//  Created by erumaru on 10/30/19.
//  Copyright © 2019 KBTU. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class AuthViewController: UIViewController, AuthUIDelegate {
    // MARK: - Constants
    private struct Constants {
        static let phoneTextFieldPlaceholder = "Введите номер"
        static let sendSMSText = "Отправить"
    }
    
    // MARK: - Outlets
    lazy var phoneTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.placeholder = Constants.phoneTextFieldPlaceholder
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.textContentType = .telephoneNumber
        view.keyboardType = .phonePad
        view.returnKeyType = .done
        
        return view
    }()
    
    lazy var sendSMSButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .cyan
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Constants.sendSMSText, for: .normal)
        button.addTarget(self, action: #selector(sendSMS), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Actions
    @objc private func sendSMS() {
        guard let phone = phoneTextField.text else { return }
        
        AuthManager.shared.sendSMS(phone: phone, uiDelegate: self) { [weak self] in
            guard let self = self else { return }
            
            let vc = VerifyCodeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        markup()
    }

    // MARK: - Markup
    private func markup() {
        view.backgroundColor = .white
        
        [phoneTextField, sendSMSButton].forEach { view.addSubview($0) }
        
        phoneTextField.snp.makeConstraints() {
            $0.top.equalTo(view.snp.topMargin).offset(48)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        sendSMSButton.snp.makeConstraints() {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(16)
            $0.size.equalTo(CGSize(width: 120, height: 48))
            $0.centerX.equalToSuperview()
        }
    }
}
