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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testSongCellReuse() {
        // Given
        let tableView = UITableView()
        tableView.register(SongCell.self, forCellReuseIdentifier: "SongCell")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        let song = Song(title: "Song 1", artist: "Artist 1")
        
        // When
        cell.configure(with: song)
        
        // Then
        XCTAssertEqual(cell.titleLabel.text, "Song 1", "Incorrect title configuration")
        XCTAssertEqual(cell.artistLabel.text, "Artist 1", "Incorrect artist configuration")
    }
    
    func testSongPlayerPause() {
        // Given
        let viewController = SongHomeViewController()
        let song = Song(title: "Song 1")
        viewController.currentSong = song
        viewController.playSong()
        
        // When
        viewController.pauseSong()
        
        // Then
        XCTAssertFalse(viewController.songPlayer.isPlaying, "Song should be paused")
    }
    
    func testSongPlayerResume() {
        // Given
        let viewController = SongHomeViewController()
        let song = Song(title: "Song 1")
        viewController.currentSong = song
        viewController.playSong()
        viewController.pauseSong()
        
        // When
        viewController.resumeSong()
        
        // Then
        XCTAssertTrue(viewController.songPlayer.isPlaying, "Song should be resumed")
    }
}
