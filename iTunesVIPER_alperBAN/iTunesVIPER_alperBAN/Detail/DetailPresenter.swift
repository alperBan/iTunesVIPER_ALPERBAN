//
//  DetailPresenter.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 11.06.2023.
//
import UIKit
import Foundation

protocol DetailPresenterProtocol {
    var router2: DetailRouter? { get set }
    var view2: DetailViewController? { get set }
    func viewDidLoad()
}

class DetailPresenter: DetailPresenterProtocol {
    var router2: DetailRouter?
    var view2: DetailViewController?
    
    func viewDidLoad() {
        guard let source = view2?.getSource() else { return }
        view2?.setArtistName(source.artistName)
        view2?.setCollectionName(source.collectionName)
        view2?.setTrackName(source.trackName)
        view2?.setTrackPrice(source.trackPrice)
        view2?.setSongsImage(source.artworkUrl100)
        view2?.setCollectionPrice(source.collectionPrice)
        view2?.setprimaryGenreName(source.primaryGenreName)
        view2?.setPreviewUrl(source.previewUrl)
    }
}
