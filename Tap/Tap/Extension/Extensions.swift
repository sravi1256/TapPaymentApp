
import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
        
    }
}

