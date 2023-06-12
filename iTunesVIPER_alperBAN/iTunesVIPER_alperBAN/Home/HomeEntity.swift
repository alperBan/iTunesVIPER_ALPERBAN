//
//  HomeEntity.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 7.06.2023.
//

import Foundation

struct Song: Decodable {
    let artworkUrl100: String
    let artistName: String
    let trackName: String
    let trackPrice: Double
    let collectionName: String
    let previewUrl: String
    let collectionPrice: Double
    let primaryGenreName: String
}

struct SongsResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}
