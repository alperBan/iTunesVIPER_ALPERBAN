//
//  SongViewController.swift
//  iTunesVIPER_alperBAN
//
//  Created by Alper Ban on 8.06.2023.
//

import UIKit

class SongViewController: UIViewController {
    // SongViewController'ın içinde gösterilecek şarkıyı tutacak bir değişken tanımlayın
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Şarkı verisini kullanarak gerekli düzenlemeleri yapın
        if let song = song {
            // Örneğin, şarkının adını ekrana yazdıralım
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            label.text = song.artistName
            label.center = view.center
            view.addSubview(label)
        }
    }
}
