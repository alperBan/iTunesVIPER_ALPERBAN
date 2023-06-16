//
//  DetailView.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 16.06.2023.
//

import UIKit
import AVFoundation

class SongDetailViewController: UIViewController {
    var song: Song?
    var isPlaying = false
    var player: AVPlayer?
    var isBookmarked = false {
        didSet {
            let image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
            navigationItem.rightBarButtonItem?.image = image
        }
    }
    private var playButton: UIButton!
    override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = .white
          setupUI()
          setupNavigationBar()
          isBookmarked = CoreDataManager.shared.fetchSongs()?.contains(where: { $0.trackName == song?.trackName }) ?? false
          
          if let song = song, let url = URL(string: song.previewUrl) {
              player = AVPlayer(url: url)
          }
      }
    
    private func setupNavigationBar() {
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    private func setupUI() {
        guard let song = song else { return }
        playButton = UIButton(type: .system)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = song.trackName
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let artistLabel = UILabel()
        artistLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        artistLabel.textAlignment = .center
        artistLabel.numberOfLines = 0
        artistLabel.text = song.artistName
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let albumLabel = UILabel()
        albumLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        albumLabel.textAlignment = .center
        albumLabel.numberOfLines = 0
        albumLabel.text = "Collection: \(song.collectionName)"
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let genreLabel = UILabel()
        genreLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genreLabel.textAlignment = .center
        genreLabel.numberOfLines = 0
        genreLabel.text = "Genre: \(song.primaryGenreName)"
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let trackPriceLabel = UILabel()
        trackPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        trackPriceLabel.textAlignment = .center
        trackPriceLabel.numberOfLines = 0
        trackPriceLabel.text = "Track Price: \(song.trackPrice)"
        trackPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionPriceLabel = UILabel()
        collectionPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        collectionPriceLabel.textAlignment = .center
        collectionPriceLabel.numberOfLines = 0
        collectionPriceLabel.text = "Collection Price: \(song.collectionPrice)"
        collectionPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: song.artworkUrl100) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)
        }
        
        playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.tintColor = .systemBlue
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playButton.contentHorizontalAlignment = .fill
        playButton.contentVerticalAlignment = .fill

      
        let buttonSize: CGFloat = 60.0
        playButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

        let stackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel, albumLabel, genreLabel, trackPriceLabel, collectionPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addSubview(imageView)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),

            stackView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    @objc private func bookmarkButtonTapped() {
        isBookmarked.toggle()
        
        guard let song = song else { return }
        
        if isBookmarked {
        
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let songModel = SongModel(context: context)
            songModel.trackName = song.trackName
            songModel.artistName = song.artistName
           
            CoreDataManager.shared.saveContext()
        } else {
        
            let alertController = UIAlertController(title: "Remove Bookmark", message: "Are you sure you want to remove this bookmark?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
                self?.isBookmarked = true
            }
            let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
                if let songs = CoreDataManager.shared.fetchSongs(), let index = songs.firstIndex(where: { $0.trackName == song.trackName }) {
                    let context = CoreDataManager.shared.persistentContainer.viewContext
                    context.delete(songs[index])
                    CoreDataManager.shared.saveContext()
                    self?.isBookmarked = false
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(removeAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func playButtonTapped() {
        if let player = player {
            if isPlaying {
                player.pause()
                playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            } else {
                player.play()
                playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            }
            isPlaying.toggle()
        }
    }
    
}

