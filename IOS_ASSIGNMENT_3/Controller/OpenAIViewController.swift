//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit
import SwiftUI

class OpenAIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of ChatViewController
        let chatViewController = ChatViewController()
        
        // Add the ChatViewController's view as a child view controller
        addChild(chatViewController)
        view.addSubview(chatViewController.view)
        chatViewController.view.frame = view.bounds
        chatViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chatViewController.didMove(toParent: self)
    }
}
