//
//  ChatManager.swift
//  Firebase
//
//  Created by erumaru on 10/30/19.
//  Copyright © 2019 KBTU. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ChatDelegate: class {
    func updateChat(messages: [String])
}

class ChatManager {
    // MARK: - Variables
    private lazy var dataBaseReference = Database.database().reference()
    private var refHandle: DatabaseHandle!
    static var shared = ChatManager()
    var delegate: ChatDelegate?
    
    // MARK: - Methods
    func sendMessage(_ message: String) {
        dataBaseReference.childByAutoId().setValue(message)
    }
    
    // MARK: - Lifecycle
    init() {
        self.refHandle = self.dataBaseReference.observe(DataEventType.value) { (snapshot) in
            let postDict = snapshot.value as? [String : String] ?? [:]
            let messages = postDict.values.compactMap { $0 }
            
            self.delegate?.updateChat(messages: messages)
        }
    }
}
