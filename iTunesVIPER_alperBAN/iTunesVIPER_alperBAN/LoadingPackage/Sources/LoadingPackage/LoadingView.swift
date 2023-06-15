//
//  LoadingView.swift
//  
//
//  Created by Alper Ban on 15.06.2023.
//

import Foundation
import UIKit

public class LoadingView {
    public var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    public static let shared = LoadingView()
    public var blurView: UIVisualEffectView = UIVisualEffectView()

    private init() {
        configure()
    }

    public func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
         activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        blurView.contentView.addSubview(activityIndicator)
    }

    public func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
    }

    public func hideLoading() {
        DispatchQueue.main.async {
            self.blurView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
    }
}
