//
//  InteractorHOME.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 7.06.2023.
//

import Foundation

protocol AnyInteractor {
    var presenter : AnyPresenter? {get set}
    var searchWord: String { get set }
    func downloadSong()
    
}

class SongInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    var searchWord: String = ""

    func downloadSong() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchWord)&country=TR&entity=song") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data , error == nil else {
                self?.presenter?.interactorDidDownloadSong(result: .failure(NetworkError.NetworkFailed))
                return
            }

            do {
                let songsResponse = try JSONDecoder().decode(SongsResponse.self, from: data)
                self?.presenter?.interactorDidDownloadSong(result: .success(songsResponse.results))
            } catch {
                self?.presenter?.interactorDidDownloadSong(result: .failure(NetworkError.ParsingFailed))
            }
        }
        task.resume()
    }
}
