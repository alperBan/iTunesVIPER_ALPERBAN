//
//  iTunesVIPER_alperBANTests.swift
//  iTunesVIPER_alperBANTests
//
//  Created by Alper Ban on 7.06.2023.
//

//  iTunesVIPER_alperBANTests.swift
//  iTunesVIPER_alperBANTests
//
//  Created by Alper Ban on 7.06.2023.
//

import XCTest
@testable import iTunesVIPER_alperBAN

final class iTunesVIPER_alperBANTests: XCTestCase {

    var viewController: SongHomeViewController!
    var songCell: SongCell!

    override func setUpWithError() throws {
        viewController = SongHomeViewController()
        viewController.loadViewIfNeeded()

        songCell = SongCell(style: .default, reuseIdentifier: "SongCell")
    }

    override func tearDownWithError() throws {
        viewController = nil
        songCell = nil
    }

    func testSongCellReuse() {
        let tableView = UITableView()
        tableView.register(SongCell.self, forCellReuseIdentifier: "SongCell")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        let song = Song(title: "Song 1", artist: "Artist 1")

        cell.configure(with: song)

        XCTAssertEqual(cell.titleLabel.text, "Song 1", "Incorrect title configuration")
        XCTAssertEqual(cell.artistLabel.text, "Artist 1", "Incorrect artist configuration")
    }

    func testSongPlayerPause() {
        let song = Song(title: "Song 1")
        viewController.currentSong = song
        viewController.playSong()

        viewController.pauseSong()

        XCTAssertFalse(viewController.songPlayer.isPlaying, "Song should be paused")
    }

    func testSongPlayerResume() {
        let song = Song(title: "Song 1")
        viewController.currentSong = song
        viewController.playSong()
        viewController.pauseSong()

        viewController.resumeSong()

        XCTAssertTrue(viewController.songPlayer.isPlaying, "Song should be resumed")
    }
}
