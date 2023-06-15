//
//  HomeView.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 7.06.2023.
//
import LoadingPackage
import SDWebImage
import Foundation
import UIKit
import AVFoundation

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    func update(with songs: [Song])
    func update(with error: String)
    
}

class SongHomeViewController: UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoadingShowable {
    var presenter: AnyPresenter?
    var selectedSong: Song?
    var songs: [Song] = []
    var textField: UITextField!
  func showLoading() {
    LoadingView.shared.startLoading()
  }

  func hideLoading() {
    LoadingView.shared.hideLoading()
  }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Best Song is Loading"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupSearchTextField()
        setupGestureRecognizer()
        let textField = view.subviews.first(where: { $0 is UITextField }) as? UITextField
            textField?.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    


    private func setupTableView() {
        view.addSubview(tableView)
        let leadingSpacing: CGFloat = 1.0
        let trailingSpacing: CGFloat = 1.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingSpacing).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingSpacing).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor.systemGray6.cgColor
        tableView.layer.cornerRadius = 11.0
        let backgroundImage = UIImageView(image: UIImage(named: "111"))
            backgroundImage.contentMode = .scaleAspectFill
            tableView.backgroundView = backgroundImage
    }



    private func setupSearchTextField() {
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.returnKeyType = .search
        
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "delete.left"), for: .normal)
        clearButton.tintColor = .systemGray3
        clearButton.contentMode = .scaleAspectFit
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)

        textField.autocorrectionType = .no
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.borderStyle = .line
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.cornerRadius = 11.0
        textField.layer.masksToBounds = true
        textField.backgroundColor = .systemGray6
        
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = .systemGray2
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.translatesAutoresizingMaskIntoConstraints = false

        textField.leftView = searchImageView
        textField.leftViewMode = .always

        view.addSubview(textField)

        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func clearButtonTapped() {
        if let textField = view.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.text = "" // textField'a erişmek için önceki yerel değişken kaldırıldı
                   presenter?.interactor?.searchWord = ""
    
            songs = []
            tableView.reloadData()
            messageLabel.isHidden = false
            tableView.isHidden = true
            messageLabel.text = "Best Song is Loading"
        }
    }
    @objc private func textFieldEditingDidBegin() {
        if songs.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardAppearance = .dark
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let textField = view.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.becomeFirstResponder()
        }
    }
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      if let searchTerm = textField.text, !searchTerm.isEmpty {
          let mergedTerm = searchTerm.replacingOccurrences(of: " ", with: "")
          let convertedTerm = convertTurkishCharacters(mergedTerm)

          presenter?.interactor?.searchWord = convertedTerm
          showLoading()
          presenter?.interactor?.downloadSong()
      } else {
          let alertController = UIAlertController(title: "Warning", message: "Please enter a search term", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(okAction)
          present(alertController, animated: true, completion: nil)

          songs = []
          tableView.reloadData()
          messageLabel.isHidden = false
          tableView.isHidden = true
          messageLabel.text = "No Songs Available"
      }
      return true
  }

    func convertTurkishCharacters(_ input: String) -> String {
        let turkishCharacters = ["ı": "i", "ğ": "g", "ü": "u", "ş": "s", "ö": "o", "ç": "c", "İ": "I", "Ğ": "G", "Ü": "U", "Ş": "S", "Ö": "O", "Ç": "C"]
        
        var convertedString = input
        for (turkishChar, englishChar) in turkishCharacters {
            convertedString = convertedString.replacingOccurrences(of: turkishChar, with: englishChar)
        }
        return convertedString
    }
    
 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let song = songs[indexPath.row]
        
        let imageView = UIImageView(frame: CGRect(x: 3, y: 3, width: 90, height: 90))
        imageView.backgroundColor = .lightGray
        cell.contentView.addSubview(imageView)
        
        if let url = URL(string: song.artworkUrl100) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 120, y: 0, width: cell.contentView.frame.width - 180, height: 30))
        titleLabel.text = songs[indexPath.row].trackName
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        cell.contentView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel(frame: CGRect(x: 120, y: 35, width: cell.contentView.frame.width - 180, height: 20))
        subtitleLabel.text = songs[indexPath.row].artistName
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        cell.contentView.addSubview(subtitleLabel)
        
        let extraLabel = UILabel(frame: CGRect(x: 120, y: 60, width: cell.contentView.frame.width - 180, height: 20))
        extraLabel.text = "Collection : \(songs[indexPath.row].collectionName)"
        extraLabel.font = UIFont.systemFont(ofSize: 15)
        extraLabel.textColor = .gray
        cell.contentView.addSubview(extraLabel)

        let detailButton = UIButton(frame: CGRect(x: cell.contentView.frame.width - 48, y: 25, width: 35, height: 35))
        detailButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        detailButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        detailButton.setTitleColor(.systemBlue, for: .normal)
        detailButton.contentHorizontalAlignment = .fill
        detailButton.contentVerticalAlignment = .fill
        detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
        cell.contentView.addSubview(detailButton)

        return cell
    }

    
    @objc private func detailButtonTapped(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            let song = songs[indexPath.row]
            if let player = self.player, let currentItem = player.currentItem {
                if let currentURL = currentItem.asset as? AVURLAsset, currentURL.url.absoluteString == song.previewUrl {
                    if player.timeControlStatus == .playing {
                        player.pause()
                        sender.setImage(UIImage(systemName: "play.circle"), for: .normal)
                    } else {
                        player.play()
                        sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
                    }
                } else {
                    pauseCurrentlyPlayingSong()
                    playAudio(from: song.previewUrl)
                    sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
                }
            } else {
                pauseCurrentlyPlayingSong()
                playAudio(from: song.previewUrl)
                sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            }
        }
    }

    private func pauseCurrentlyPlayingSong() {
        if let player = self.player, let currentItem = player.currentItem {
            player.pause()
            if let currentIndexPath = findIndexPath(for: currentItem) {
                if let cell = tableView.cellForRow(at: currentIndexPath) {
                    if let detailButton = cell.contentView.subviews.first(where: { $0 is UIButton }) as? UIButton {
                        detailButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
                    }
                }
            }
        }
    }

    private func findIndexPath(for playerItem: AVPlayerItem) -> IndexPath? {
        for (index, song) in songs.enumerated() {
            if let currentURL = playerItem.asset as? AVURLAsset, currentURL.url.absoluteString == song.previewUrl {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
    private var player: AVPlayer?

    private func playAudio(from url: String) {
        guard let audioURL = URL(string: url) else {
          
            return
        }

        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }

    func update(with songs: [Song]) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.songs = songs
            self.tableView.reloadData()
            
            if songs.isEmpty && self.textField.text?.isEmpty == false {
                let alertController = UIAlertController(title: "Hata", message: "Arama sonucunda şarkı bulunamadı.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.tableView.isHidden = true
                self.messageLabel.isHidden = true
            } else {
                self.tableView.isHidden = false
                self.messageLabel.isHidden = true
            }
        }
    }

  func update(with error: String) {
      DispatchQueue.main.async {
          self.hideLoading()
          self.songs = []
          self.tableView.isHidden = true
          self.messageLabel.text = error
          self.messageLabel.isHidden = false
      }
  }

}

