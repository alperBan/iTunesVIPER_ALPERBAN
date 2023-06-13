//
//  BaseViewController.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 11.06.2023.
//

import UIKit
import LoadingPackage

class BaseViewController: UIViewController,LoadingShowable{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
}

