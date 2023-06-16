//  iTunesVIPER_alperBANUITests.swift
//  iTunesVIPER_alperBANUITests
//
//  Created by Alper Ban on 7.06.2023.
//

import XCTest
@testable import iTunesVIPER_alperBAN

final class SongHomeViewControllerTests: XCTestCase {

    var viewController: SongHomeViewController!
    var presenterMock: PresenterMock!
    var playerMock: PlayerMock!

    override func setUpWithError() throws {
        viewController = SongHomeViewController()
        viewController.loadViewIfNeeded()

        presenterMock = PresenterMock()
        viewController.presenter = presenterMock

        playerMock = PlayerMock()
        viewController.player = playerMock
    }

    override func tearDownWithError() throws {
        viewController = nil
        presenterMock = nil
        playerMock = nil
    }

    func testViewDidLoad() {
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.messageLabel)
        XCTAssertEqual(viewController.messageLabel.text, "Best Song is Loading")
        XCTAssertNil(viewController.presenter)
        XCTAssertTrue(viewController.tableView.isHidden)
    }

    func testClearButtonTapped() {
        viewController.songs = [Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1")]
        viewController.tableView.reloadData()

        viewController.clearButtonTapped()

        XCTAssertTrue(presenterMock.clearSearchCalled)
        XCTAssertEqual(viewController.songs, [])
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "Best Song is Loading")
    }

    func testTextFieldShouldReturn_WithEmptyText() {
        viewController.textField.text = ""

        let returnValue = viewController.textFieldShouldReturn(viewController.textField)

        XCTAssertFalse(returnValue)
        XCTAssertFalse(presenterMock.fetchSongsCalled)
        XCTAssertEqual(viewController.songs, [])
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "No Songs Available")
    }

    func testTextFieldShouldReturn_WithSearchTerm() {
        viewController.textField.text = "Test"

        let returnValue = viewController.textFieldShouldReturn(viewController.textField)

        XCTAssertTrue(returnValue)
        XCTAssertTrue(presenterMock.fetchSongsCalled)
        XCTAssertEqual(presenterMock.searchTerm, "Test")
    }

    func testDetailButtonTapped_PlayingSameSong() {
        viewController.songs = [Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1")]
        viewController.tableView.reloadData()

        let detailButton = UIButton()
        detailButton.tag = 0
        viewController.detailButtonTapped(detailButton)

        XCTAssertTrue(playerMock.togglePlayPauseCalled)
    }

    func testDetailButtonTapped_PlayingDifferentSong() {
        viewController.songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.tableView.reloadData()

        let detailButton = UIButton()
        detailButton.tag = 1
        viewController.detailButtonTapped(detailButton)

        XCTAssertTrue(playerMock.pauseCalled)
        XCTAssertTrue(playerMock.playCalled)
    }

    func testDetailButtonTapped_PlayingFirstTime() {
        viewController.songs = [Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1")]
        viewController.tableView.reloadData()

        let detailButton = UIButton()
        detailButton.tag = 0
        viewController.detailButtonTapped(detailButton)

        XCTAssertTrue(playerMock.playCalled)
    }

    func testSongPlayerPause() {
        let song = Song(trackName: "Song 1")
        viewController.currentSong = song
        viewController.playSong()

        viewController.pauseSong()

        XCTAssertFalse(playerMock.isPlaying)
    }

    func testSongPlayerResume() {
        let song = Song(trackName: "Song 1")
        viewController.currentSong = song
        viewController.playSong()
        viewController.pauseSong()

        viewController.resumeSong()

        XCTAssertTrue(playerMock.isPlaying)
    }

    func testTableViewDidSelectRowAtIndexPath() {
        let songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.songs = songs
        viewController.tableView.reloadData()

        let indexPath = IndexPath(row: 1, section: 0)
        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: indexPath)

        XCTAssertTrue(presenterMock.didSelectSongCalled)
        XCTAssertEqual(presenterMock.selectedSong, songs[indexPath.row])
    }

    func testUpdateTableView() {
        let songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.songs = songs

        viewController.updateTableView()

        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), songs.count)
    }
}
