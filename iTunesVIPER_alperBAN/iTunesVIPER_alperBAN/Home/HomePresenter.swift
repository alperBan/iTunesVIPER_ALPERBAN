//
// HomePresenter.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 7.06.2023.
//

import Foundation
//Class, protocol
// talks to interactor, router, view

enum NetworkError : Error {
    case NetworkFailed
    case ParsingFailed
}

protocol AnyPresenter{
    var router : AnyRouter? {get set}
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    
    func interactorDidDownloadSong(result: Result<[Song],Error>)
}

class SongPresenter : AnyPresenter {
    var router: AnyRouter?
    
    var interactor: AnyInteractor?{
        didSet {
            interactor?.downloadSong()
        }
    }
    var view: AnyView?
    
    func interactorDidDownloadSong(result: Result<[Song], Error>) {
        switch result {
        case .success(let songs):
            view?.update(with: songs)
        case .failure(_):
            view?.update(with: "Try Again")
        }
    }
    
    
}
