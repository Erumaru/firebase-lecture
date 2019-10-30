//
//  VerifyCodeViewController.swift
//  Firebase
//
//  Created by erumaru on 10/30/19.
//  Copyright © 2019 KBTU. All rights reserved.
//

import UIKit

class VerifyCodeViewController: UIViewController {
    // MARK: - Constants
    private struct Constants {
        static let phoneTextFieldPlaceholder = "Введите код"
        static let sendSMSText = "Отправить"
    }
    
    // MARK: - Outlets
    lazy var codeTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.placeholder = Constants.phoneTextFieldPlaceholder
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.textContentType = .oneTimeCode
        view.keyboardType = .numberPad
        view.returnKeyType = .done
        
        return view
    }()
    
    lazy var checkSMSButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .cyan
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Constants.sendSMSText, for: .normal)
        button.addTarget(self, action: #selector(checkSMS), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Actions
    @objc private func checkSMS() {
        guard let code = codeTextField.text else { return }
        
        AuthManager.shared.checkSMS(code: code) { [weak self] message in
            guard let self = self else { return }
            if let message = message {
                print(message)
                return
            }
            
            let vc = ChatViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
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
        
        [codeTextField, checkSMSButton].forEach { view.addSubview($0) }
        
        codeTextField.snp.makeConstraints() {
            $0.top.equalTo(view.snp.topMargin).offset(48)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        checkSMSButton.snp.makeConstraints() {
            $0.top.equalTo(codeTextField.snp.bottom).offset(16)
            $0.size.equalTo(CGSize(width: 120, height: 48))
            $0.centerX.equalToSuperview()
        }
    }

}
