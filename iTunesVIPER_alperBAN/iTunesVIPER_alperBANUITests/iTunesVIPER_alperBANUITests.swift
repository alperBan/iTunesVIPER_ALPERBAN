//  iTunesVIPER_alperBANUITests.swift
//  iTunesVIPER_alperBANUITests
//
//  Created by Alper Ban on 7.06.2023.
//

import XCTest
@testable import iTunesVIPER_alperBAN

final class SongHomeViewControllerTests: XCTestCase {
    
    var viewController: SongHomeViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = SongHomeViewController()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        
        super.tearDown()
    }
    
    func testViewDidLoad() {
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.messageLabel)
        XCTAssertEqual(viewController.messageLabel.text, "Best Song is Loading")
        XCTAssertNil(viewController.presenter)
        XCTAssertTrue(viewController.tableView.isHidden)
    }
    
    func testClearButtonTapped() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        viewController.songs = [Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1")]
        viewController.tableView.reloadData()
        
        viewController.clearButtonTapped()
        
        XCTAssertTrue(presenterMock.clearSearchCalled)
        XCTAssertEqual(viewController.songs, [])
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "Best Song is Loading")
    }
    
    func testTextFieldShouldReturn_WithEmptyText() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        viewController.textField.text = ""
        
        let returnValue = viewController.textFieldShouldReturn(viewController.textField)
        
        XCTAssertFalse(returnValue)
        XCTAssertFalse(presenterMock.fetchSongsCalled)
        XCTAssertEqual(viewController.songs, [])
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "No Songs Available")
    }
    
    func testTextFieldShouldReturn_WithSearchTerm() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        viewController.textField.text = "Test"
        
        let returnValue = viewController.textFieldShouldReturn(viewController.textField)
        
        XCTAssertTrue(returnValue)
        XCTAssertTrue(presenterMock.fetchSongsCalled)
        XCTAssertEqual(presenterMock.searchTerm, "Test")
    }
    
    func testDetailButtonTapped_PlayingSameSong() {
        let playerMock = PlayerMock()
        viewController.player = playerMock
        viewController.songs = [Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1")]
        viewController.tableView.reloadData()
        
        let detailButton = UIButton()
        detailButton.tag = 0
        viewController.detailButtonTapped(detailButton)
        
        XCTAssertTrue(playerMock.togglePlayPauseCalled)
    }
    
    func testDetailButtonTapped_PlayingDifferentSong() {
        let playerMock = PlayerMock()
        viewController.player = playerMock
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
        let playerMock = PlayerMock()
        viewController.player = playerMock
        viewController.songs = []
        viewController.tableView.reloadData()
        
        let detailButton = UIButton()
        detailButton.tag = 0
        viewController.detailButtonTapped(detailButton)
        
        XCTAssertTrue(playerMock.playCalled)
    }
    
    func testFetchSongsSuccess() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        let songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.fetchSongsSuccess(songs)
        
        XCTAssertEqual(viewController.songs, songs)
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "No Songs Available")
    }
    
    func testFetchSongsFailure() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        viewController.fetchSongsFailure()
        
        XCTAssertEqual(viewController.songs, [])
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.messageLabel.text, "Failed to Fetch Songs")
    }
    
    func testSearchButtonTapped() {
        let presenterMock = PresenterMock()
        viewController.presenter = presenterMock
        
        viewController.textField.text = "Test"
        viewController.searchButtonTapped(UIButton())
        
        XCTAssertTrue(presenterMock.fetchSongsCalled)
        XCTAssertEqual(presenterMock.searchTerm, "Test")
    }
    
    func testTableViewNumberOfRowsInSection() {
        viewController.songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.tableView.reloadData()
        
        let numberOfRows = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testTableViewCellForRowAtIndexPath() {
        let songs = [
            Song(trackName: "Song 1", artistName: "Artist 1", collectionName: "Collection 1", artworkUrl100: "url1", previewUrl: "url1"),
            Song(trackName: "Song 2", artistName: "Artist 2", collectionName: "Collection 2", artworkUrl100: "url2", previewUrl: "url2")
        ]
        viewController.songs = songs
        viewController.tableView.reloadData()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath) as? SongTableViewCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.songTitleLabel.text, songs[indexPath.row].trackName)
        XCTAssertEqual(cell?.artistNameLabel.text, songs[indexPath.row].artistName)
    }
}
