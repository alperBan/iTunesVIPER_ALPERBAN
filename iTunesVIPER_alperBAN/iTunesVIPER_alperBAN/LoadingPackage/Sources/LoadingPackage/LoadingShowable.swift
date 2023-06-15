//
//  LoadingShowable.swift
//  
//
//  Created by Alper Ban on 15.06.2023.
//

import Foundation
import UIKit

public protocol LoadingShowable where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }

    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}
