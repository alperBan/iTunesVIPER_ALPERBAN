//
//  DetailViewController.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 11.06.2023.
//

import UIKit

protocol DetailView {
    var presenter: DetailPresenterProtocol? { get set }
    func update(with songs: [Song])
    func update(with error: String)
}

protocol DetailViewControllerProtocol: AnyObject {
    func setArtistName(_ text: String)
    func setCollectionName(_ text: String)
    func setTrackName(_ text: String)
    func setTrackPrice(_ text: Double)
    func setSongsImage(_ text: String)
    func setCollectionPrice(_ text: Double)
    func setprimaryGenreName(_ text: String)
    func setPreviewUrl(_ text: String)
    func getSource() -> Song?
}

final class DetailViewController: UIViewController {
    @IBOutlet weak var imgSongs: UIImageView!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var collectionLbl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var trackNameLbl: UILabel!
    @IBOutlet weak var kindLbl: UILabel!
    @IBOutlet weak var trackPrice: UILabel!
    @IBOutlet weak var collectionPrice: UILabel!
    
    var presenter: DetailPresenterProtocol!
    var source: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func getSource() -> Song? {
        return source
    }
    
    func setArtistName(_ text: String) {
        self.artistLbl.text = text
    }
    
    func setCollectionName(_ text: String) {
        self.collectionLbl.text = text
    }
    
    func setTrackName(_ text: String) {
        self.trackNameLbl.text = text
    }
    
    func setTrackPrice(_ text: Double) {
        self.trackPrice.text = "\(text)"
    }
    
    func setSongsImage(_ text: String) {
        // Set the image using the URL or any other method
    }
    
    func setCollectionPrice(_ text: Double) {
        self.collectionPrice.text = "\(text)"
    }
    
    func setprimaryGenreName(_ text: String) {
        self.kindLbl.text = text
    }
    
    func setPreviewUrl(_ text: String) {
        // Set the preview URL or handle it as needed
    }
}
