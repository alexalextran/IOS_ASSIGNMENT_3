//
//  ChatViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 26/5/2023.
//

import UIKit
import SwiftUI

class ChatViewController: UIHostingController<ChatView> {
    init() {
        let chatView = ChatView()
        super.init(rootView: chatView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
