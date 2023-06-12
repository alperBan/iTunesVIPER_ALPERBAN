//
//  DetailRouter.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 11.06.2023.
//

import UIKit
import Foundation

//entryPoint



protocol DetaiRouter{
    var entry: EntryPoint? {get}
    static func startExecution() -> DetaiRouter
}

class DetailRouter : AnyRouter {
    var entry: EntryPoint?
    
    static func startExecution() -> AnyRouter {
        let router = SongRouter()
        
        var view: AnyView = SongHomeViewController()
        var presenter: AnyPresenter = SongPresenter()
        var interactor : AnyInteractor = SongInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return router
        
    }
    
    
}
