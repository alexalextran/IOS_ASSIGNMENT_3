import UIKit

class NavbarController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    @objc func thoughtsButtonTapped() {
        let journalEntryViewController = JournalEntryViewController()
        setViewControllers([journalEntryViewController], animated: true)
    }

    // Other methods and code for your NavbarController
}
